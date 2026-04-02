import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';
import 'package:meetnow_frontend/features/chat/domain/repositories/chat_repository.dart';

/// 메시지를 전송하는 유스케이스.
///
/// [type] 기본값은 [MessageType.text]입니다.
/// 성공 시 전송된 메시지 데이터가 담긴 [Message]를 반환합니다.
class SendMessage {
  final ChatRepository _repository;

  const SendMessage(this._repository);

  ResultFuture<Message> call({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
  }) {
    return _repository.sendMessage(
      chatId: chatId,
      content: content,
      type: type,
    );
  }
}
