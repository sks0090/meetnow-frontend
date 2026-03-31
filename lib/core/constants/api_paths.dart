/// 백엔드 API의 엔드포인트 경로를 정의합니다.
///
/// [Env.baseUrl]과 조합하여 완전한 URL을 생성합니다.
/// 경로를 변경할 때 이 파일만 수정하면 됩니다.
abstract class ApiPaths {
  // ── 인증 (Auth) ──────────────────────────────────────────────────────────
  static const String socialLogin = '/auth/social';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String verifyPhone = '/auth/verify-phone';
  static const String verifyCode = '/auth/verify-code';

  // ── 사용자 / 프로필 ───────────────────────────────────────────────────────
  static const String profile = '/users/me'; // 내 프로필 조회/수정
  static const String updateProfile = '/users/me';
  static const String uploadPhoto = '/users/me/photos';

  /// 특정 사진을 삭제할 때 사용합니다. [photoId]에 삭제할 사진 ID를 전달합니다.
  static String deletePhoto(String photoId) => '/users/me/photos/$photoId';

  /// 다른 사용자의 공개 프로필을 조회합니다.
  static String userProfile(String userId) => '/users/$userId';

  // ── 매칭 (Match) ─────────────────────────────────────────────────────────
  static const String discover = '/matches/discover'; // 탐색할 프로필 목록
  static const String like = '/matches/like';
  static const String dislike = '/matches/dislike';
  static const String matches = '/matches';

  /// 특정 매칭을 취소합니다.
  static String unmatch(String matchId) => '/matches/$matchId';

  // ── 채팅 (Chat) ───────────────────────────────────────────────────────────
  static const String chats = '/chats'; // 채팅방 목록
  /// 특정 채팅방의 메시지 목록을 가져오거나 메시지를 전송합니다.
  static String chatMessages(String chatId) => '/chats/$chatId/messages';
  static String chatDetail(String chatId) => '/chats/$chatId';

  // ── 알림 (Notification) ───────────────────────────────────────────────────
  static const String notifications = '/notifications';

  /// FCM 디바이스 토큰을 서버에 등록합니다.
  static const String registerDevice = '/notifications/device';
}
