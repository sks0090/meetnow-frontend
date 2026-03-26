import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/chat.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';

/// 채팅 관련 데이터 조작의 계약(Contract).
///
/// REST API와 WebSocket을 모두 담당합니다.
abstract class ChatRepository {
  /// 내가 속한 전체 채팅방 목록을 반환합니다.
  ResultFuture<List<Chat>> getChatList();

  /// [chatId] 채팅방의 메시지를 페이지 단위로 반환합니다.
  ResultFuture<List<Message>> getMessages(String chatId, {int page = 1});

  /// 메시지를 전송하고 전송된 [Message]를 반환합니다.
  ResultFuture<Message> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
  });

  /// WebSocket으로 실시간 메시지를 구독합니다.
  /// 메시지가 도착할 때마다 [Message]를 emit합니다.
  Stream<Message> subscribeToMessages(String chatId);
}
