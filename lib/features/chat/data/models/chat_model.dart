import 'package:meetnow_frontend/features/chat/data/models/message_model.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/chat.dart';

/// [Chat] 엔티티의 데이터 모델 (JSON 역직렬화 담당).
///
/// 서버 API의 snake_case JSON 필드를 Dart 객체로 변환합니다.
/// [Chat]을 확장(extends)하므로 도메인 레이어에도 타입으로 직접 사용할 수 있습니다.
class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.matchId,
    required super.participantId,
    required super.participantName,
    super.participantAvatarUrl,
    super.lastMessage,
    super.unreadCount,
    required super.updatedAt,
  });

  /// JSON 맵에서 [ChatModel]을 생성합니다.
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      matchId: json['match_id'] as String,
      participantId: json['participant_id'] as String,
      participantName: json['participant_name'] as String,
      participantAvatarUrl: json['participant_avatar_url'] as String?,
      lastMessage: json['last_message'] != null
          ? MessageModel.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
