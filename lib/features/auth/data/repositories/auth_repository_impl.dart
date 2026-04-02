import 'package:fpdart/fpdart.dart';
import 'package:meetnow_frontend/core/error/exceptions.dart';
import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:meetnow_frontend/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:meetnow_frontend/features/auth/domain/entities/user.dart';
import 'package:meetnow_frontend/features/auth/domain/repositories/auth_repository.dart';

/// [AuthRepository]의 실제 구현체.
///
/// 원격([AuthRemoteDataSource])과 로컬([AuthLocalDataSource])을 조합하여
/// 비즈니스 로직을 처리합니다.
///
/// 패턴:
/// - [AuthRemoteDataSource]에서 예외를 받으면 [Failure]로 변환해 [Left]로 감쌉니다.
/// - 성공 결과는 [Right]로 감싸서 반환합니다.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  ResultFuture<User> loginWithSocial({
    required String provider,
    required String token,
  }) async {
    try {
      // 1) 서버에 소셜 로그인 요청 (provider + token)
      final result = await _remoteDataSource.loginWithSocial(
        provider: provider,
        token: token,
      );
      // 2) 응답으로 받은 토큰을 로컬 보안 저장소에 저장
      await _localDataSource.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      // 3) 성공 → User 엔티티를 Right로 반환
      return Right(result.user);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await _remoteDataSource.logout(); // 서버 측 토큰 무효화
      await _localDataSource.clearTokens(); // 로컬 토큰 삭제
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<User> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> refreshToken() async {
    try {
      // 1) 로컬에 저장된 리프레시 토큰 읽기
      final token = await _localDataSource.getRefreshToken();
      if (token == null) {
        return const Left(AuthFailure(message: '리프레시 토큰이 없습니다.'));
      }
      // 2) 서버에 새 토큰 발급 요청
      final newTokens = await _remoteDataSource.refreshToken(token);
      // 3) 새 토큰을 로컬에 다시 저장
      await _localDataSource.saveTokens(
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
      );
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<bool> isLoggedIn() => _localDataSource.hasTokens();
}
