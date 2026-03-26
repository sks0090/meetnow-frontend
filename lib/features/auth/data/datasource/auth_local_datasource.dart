import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meetnow_frontend/core/constants/app_constants.dart';

/// 로컈 인증 데이터 의존성의 계약(Contract).
///
/// 토큰을 안전하게 저장/조회/삭제하는 메서드를 정의합니다.
abstract class AuthLocalDataSource {
  /// 액세스/리프레시 토큰을 보안 저장소에 저장합니다.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// 저장된 액세스 토큰을 반환합니다. 없으면 null.
  Future<String?> getAccessToken();

  /// 저장된 리프레시 토큰을 반환합니다. 없으면 null.
  Future<String?> getRefreshToken();

  /// 모든 토큰을 삭제합니다 (로그아웃 시 사용).
  Future<void> clearTokens();

  /// 로컈에 토큰이 있는지 여부를 반환합니다.
  Future<bool> hasTokens();
}

/// [AuthLocalDataSource]의 [FlutterSecureStorage] 기반 구현체.
///
/// iOS 키체인, Android Keystore를 통해 토큰을 암호화하여 저장합니다.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  const AuthLocalDataSourceImpl(this._storage);

  /// 액세스/리프레시 토큰을 병렬로 (두 작업 동시 실행) 저장합니다.
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.accessTokenKey, value: accessToken),
      _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken),
    ]);
  }

  @override
  Future<String?> getAccessToken() {
    return _storage.read(key: AppConstants.accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(key: AppConstants.refreshTokenKey);
  }

  /// 액세스/리프레시 토큰을 병렬로 삭제합니다.
  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: AppConstants.accessTokenKey),
      _storage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }

  @override
  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null;
  }
}
