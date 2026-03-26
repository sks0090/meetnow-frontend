/// 앱 전역에서 사용되는 상수를 정의합니다.
///
/// 매직 숫자 대신 이 클래스의 상수를 사용하면 의도를 명확히 전달하고
/// 향후 값을 변경할 때 한 파일만 수정하면 됩니다.
abstract class AppConstants {
  static const String appName = 'MeetNow';

  // ── 페이지네이션 ──────────────────────────────────────────────────────────
  /// API 요청 시 한 번에 가져오는 아이템 수.
  static const int defaultPageSize = 20;

  // ── 이미지 / 프로필 제한 ──────────────────────────────────────────────────
  /// 업로드 허용 최대 이미지 파일 크기 (MB).
  static const int maxImageUploadSizeMB = 10;

  /// 사용자가 등록할 수 있는 프로필 사진 최대 개수.
  static const int maxProfilePhotos = 6;

  // ── 프로필 입력 제한 ──────────────────────────────────────────────────────
  static const int minAge = 18; // 서비스 이용 최소 나이
  static const int maxAge = 100;
  static const int maxBioLength = 500;

  // ── 채팅 ──────────────────────────────────────────────────────────────────
  static const int maxMessageLength = 1000;

  // ── 매칭 ──────────────────────────────────────────────────────────────────
  /// km 단위 기본 검색 반경.
  static const double defaultSearchRadiusKm = 50.0;

  // ── 네트워크 타임아웃 ─────────────────────────────────────────────────────
  /// API 원시 커넥션 타임아웃.
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// API 응답 수신 타임아웃.
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── 로컬 스토리지 키 ──────────────────────────────────────────────────────
  /// FlutterSecureStorage 저장 키: 액세스 토큰.
  static const String accessTokenKey = 'access_token';

  /// FlutterSecureStorage 저장 키: 리프레시 토큰.
  static const String refreshTokenKey = 'refresh_token';

  /// SharedPreferences 저장 키: 마지막으로 로그인한 사용자 ID.
  static const String userIdKey = 'user_id';
}
