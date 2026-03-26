import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/core/network/api_client.dart';
import 'package:meetnow_frontend/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:meetnow_frontend/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/chat.dart';
import 'package:meetnow_frontend/features/chat/domain/repositories/chat_repository.dart';

/// [ChatRepository] 인스턴스를 제공하는 Provider.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepositoryImpl(ChatRemoteDataSourceImpl(dio));
});

/// 채팅방 목록을 관리하는 AsyncNotifierProvider.
final chatListProvider =
    AsyncNotifierProvider<ChatListNotifier, List<Chat>>(ChatListNotifier.new);

/// 채팅 목록의 상태를 관리하는 AsyncNotifier.
///
/// 빌드 시 이덕스 데이터를 불러오고, [refresh]로 수동 새로고침을 지원합니다.
class ChatListNotifier extends AsyncNotifier<List<Chat>> {
  @override
  Future<List<Chat>> build() async {
    return _fetchChats();
  }

  Future<List<Chat>> _fetchChats() async {
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.getChatList();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (chats) => chats,
    );
  }

  /// 그닉 새로고침 시 호출합니다 (pull-to-refresh 등).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchChats());
  }
}
