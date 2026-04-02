import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';
import 'package:meetnow_frontend/features/chat/domain/repositories/chat_repository.dart';

/// WebSocket 등을 통해 실시간 메시지를 구독하는 유스케이스.
///
/// 반환된 [Stream<Message>]는 데이터 레이어 구현에 따라
/// 폴링 스트림 또는 WebSocket 실시간 스트림이 됩니다.
class SubscribeMessages {
  final ChatRepository _repository;

  const SubscribeMessages(this._repository);

  Stream<Message> call(String chatId) =>
      _repository.subscribeToMessages(chatId);
}
