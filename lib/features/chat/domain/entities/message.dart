/// 데이팅 앱에서 다루는 채팅 메시지 도메인 엔티티.
class Message {
  final String id;
  final String chatId; // 속한 채팅방 ID
  final String senderId; // 직접 츼 노드는 내 ID
  final String content; // 문자 또는 이미지 URL
  final MessageType type;
  final DateTime createdAt;
  final bool isRead; // 상대방이 읽었으면 true

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
    required this.createdAt,
    this.isRead = false,
  });
}

/// 메시지 유형.
///
/// - [text]: 일반 텍스트 메시지
/// - [image]: 이미지 URL
/// - [gif]: GIF URL
enum MessageType { text, image, gif }
