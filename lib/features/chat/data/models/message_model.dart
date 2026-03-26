import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';

/// [Message] 엔티티의 데이터 모델 (JSON 역직렬화/직렬화 담당).
///
/// [MessageType]은 JSON에서 byName으로 역직렬화합니다 (null이면 'text').
class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.content,
    super.type,
    required super.createdAt,
    super.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      type: MessageType.values.byName(json['type'] as String? ?? 'text'),
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}
