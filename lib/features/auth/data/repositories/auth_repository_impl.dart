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
      final result = await _remoteDataSource.loginWithSocial(
        provider: provider,
        token: token,
      );
      await _localDataSource.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
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
      await _remoteDataSource.logout();
      await _localDataSource.clearTokens();
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
      final token = await _localDataSource.getRefreshToken();
      if (token == null) {
        return const Left(AuthFailure(message: '리프레시 토큰이 없습니다.'));
      }
      final newTokens = await _remoteDataSource.refreshToken(token);
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
