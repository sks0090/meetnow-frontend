import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';
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
///
/// autoDispose + keepAlive(5분)로 탭 전환 시 불필요한 API 재호출을 방지합니다.
final chatListProvider =
    AsyncNotifierProvider.autoDispose<ChatListNotifier, List<Chat>>(
        ChatListNotifier.new);

/// 채팅 목록의 상태를 관리하는 AutoDisposeAsyncNotifier.
///
/// 빌드 시 최초 데이터를 불러오고, [refresh]로 수동 새로고침을 지원합니다.
/// keepAlive(5분)로 탭 전환 시 상태를 유지하며, 5분 뒤 자동으로 메모리에서 해제됩니다.
class ChatListNotifier extends AutoDisposeAsyncNotifier<List<Chat>> {
  @override
  Future<List<Chat>> build() async {
    // 탭 이동 후 재진입 시 API 재호출 방지 (5분간 상태 유지)
    final link = ref.keepAlive();
    Timer(const Duration(minutes: 5), link.close);

    return _fetchChats();
  }

  Future<List<Chat>> _fetchChats() async {
    appLogger.i('[Chat] 채팅 목록 로드 중...');
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.getChatList();
    return result.fold(
      (failure) {
        appLogger.w('[Chat] 채팅 목록 로드 실패: ${failure.message}');
        throw Exception(failure.message);
      },
      (chats) {
        appLogger.i('[Chat] 채팅방 ${chats.length}개 로드 완료');
        return chats;
      },
    );
  }

  /// 수동 새로고침 시 호출합니다 (pull-to-refresh 등).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchChats());
  }
}
