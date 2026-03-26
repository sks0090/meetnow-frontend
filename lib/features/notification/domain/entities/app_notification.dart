/// 앱 내 알림 도메인 엔티티.
///
/// 푸시 알림 수신 후 앱 내 알림 목록에 표시됩니다.
/// [type]은 'match', 'message', 'like' 등 알림의 종류를 구분합니다.
/// [data]에는 타입별 추가 데이터(예: chatId)가 담길 수 있습니다.
class AppNotification {
  final String id;
  final String type; // 알림 종류 (예: 'match', 'new_message')
  final String title;
  final String body;
  final Map<String, dynamic>? data; // 알림 클릭 시 사용할 추가 데이터
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });
}
