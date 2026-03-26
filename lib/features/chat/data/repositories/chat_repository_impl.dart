import 'package:fpdart/fpdart.dart';
import 'package:meetnow_frontend/core/error/exceptions.dart';
import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/chat.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';
import 'package:meetnow_frontend/features/chat/domain/repositories/chat_repository.dart';

/// [ChatRepository] 구현체.
///
/// 데이터소스의 예외를 [Failure]로 변환하여 Either 모나드로 반환합니다.
/// subscribeToMessages는 현재 WebSocket 미구현 상태입니다.
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  const ChatRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<Chat>> getChatList() async {
    try {
      final chats = await _remoteDataSource.getChatList();
      return Right(chats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<Message>> getMessages(
    String chatId, {
    int page = 1,
  }) async {
    try {
      final messages = await _remoteDataSource.getMessages(chatId, page: page);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<Message> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      final message = await _remoteDataSource.sendMessage(
        chatId: chatId,
        content: content,
        type: type.name,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<Message> subscribeToMessages(String chatId) {
    // TODO: Implement WebSocket subscription
    return const Stream.empty();
  }
}
