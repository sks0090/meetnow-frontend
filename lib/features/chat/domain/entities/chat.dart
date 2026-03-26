import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';

/// 채팅방 도메인 엔티티.
///
/// 두 사용자 간의 1:1 대화를 나타냅니다.
/// [participantId]는 대화 상대방 ID입니다.
class Chat {
  final String id;
  final String matchId; // 이 채팅방을 열게 한 매칭 ID
  final String participantId; // 대화 상대방 사용자 ID
  final String participantName;
  final String? participantAvatarUrl;
  final Message? lastMessage; // 채팅목록에 입쬬 미리보기에 사용
  final int unreadCount; // 읽지 않은 메시지 수
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.matchId,
    required this.participantId,
    required this.participantName,
    this.participantAvatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });
}
