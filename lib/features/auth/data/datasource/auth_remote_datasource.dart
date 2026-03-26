import 'package:dio/dio.dart';
import 'package:meetnow_frontend/core/constants/api_paths.dart';
import 'package:meetnow_frontend/features/auth/data/models/token_model.dart';
import 'package:meetnow_frontend/features/auth/data/models/user_model.dart';

/// 인증 관련 원격 API 호출 계약(Contract).
///
/// 서버에 HTTP 요청을 보내 인증 데이터를 가져오는 메서드를 정의합니다.
/// 예외를 throw하면 [AuthRepositoryImpl]에서 [Failure]로 매핑합니다.
abstract class AuthRemoteDataSource {
  /// 이메일/비밀번호로 로그인합니다.
  /// 응답 JSON에서 user와 tokens를 함께 반환합니다 (Dart record 타입).
  Future<({UserModel user, TokenModel tokens})> login({
    required String email,
    required String password,
  });

  /// 신규 회원가입을 요청합니다.
  Future<({UserModel user, TokenModel tokens})> signup({
    required String name,
    required String email,
    required String password,
  });

  /// 서버에 로그아웃 요청을 보냅니다. 서버 측 토큰 무효화를 처리합니다.
  Future<void> logout();

  /// 현재 로그인된 사용자 정보를 서버에서 가져옵니다.
  Future<UserModel> getCurrentUser();

  /// 리프레시 토큰으로 새 액세스 토큰 발급을 요청합니다.
  Future<TokenModel> refreshToken(String refreshToken);
}

/// [AuthRemoteDataSource]의 Dio 기반 구현체.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<({UserModel user, TokenModel tokens})> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiPaths.login,
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    return (
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      tokens: TokenModel.fromJson(data['tokens'] as Map<String, dynamic>),
    );
  }

  @override
  Future<({UserModel user, TokenModel tokens})> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiPaths.signup,
      data: {'name': name, 'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    return (
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      tokens: TokenModel.fromJson(data['tokens'] as Map<String, dynamic>),
    );
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiPaths.logout);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiPaths.profile);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TokenModel> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      ApiPaths.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    return TokenModel.fromJson(response.data as Map<String, dynamic>);
  }
}
