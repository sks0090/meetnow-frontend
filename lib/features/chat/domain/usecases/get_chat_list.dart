import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/chat.dart';
import 'package:meetnow_frontend/features/chat/domain/repositories/chat_repository.dart';

/// 나의 채팅 목록을 가져오는 유스케이스.
///
/// 반환된 [Chat] 리스트는 최대 갱신 순으로 정렬됩니다.
class GetChatList {
  final ChatRepository _repository;

  const GetChatList(this._repository);

  ResultFuture<List<Chat>> call() => _repository.getChatList();
}
