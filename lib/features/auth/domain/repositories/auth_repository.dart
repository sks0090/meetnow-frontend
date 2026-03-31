import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/auth/domain/entities/user.dart';

/// 인증 관련 데이터 조작의 계약(Contract)를 정의하는 앱스트랙트 클래스.
///
/// 도메인 레이어는 이 인터페이스만 알고,
/// 실제 구현체([AuthRepositoryImpl]))는 데이터 레이어에 있습니다.
/// Result는 항상 [ResultFuture]로 반환해 성공/실패를 [Either]로 표현합니다.
abstract class AuthRepository {
  /// 소셜 로그인 (카카오, Apple, Google). 성공 시 [User]를 반환합니다.
  /// 서버 측에서 미가입 사용자는 자동 회원가입 처리됩니다.
  ResultFuture<User> loginWithSocial({
    required String provider,
    required String token,
  });

  /// 로그아웃. 로컈 토큰을 삭제하고 서버에 로그아웃을 알립니다.
  ResultFuture<void> logout();

  /// 로컈에 저장된 토큰으로 현재 사용자 정보를 서버에서 가져옵니다.
  ResultFuture<User> getCurrentUser();

  /// 리프레시 토큰으로 새 액세스 토큰을 발급합니다.
  ResultFuture<void> refreshToken();

  /// 로컈에 토큰이 있는지 확인합니다 (로그인 여부 판단 용도).
  Future<bool> isLoggedIn();
}
