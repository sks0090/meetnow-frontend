import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';
import 'package:meetnow_frontend/features/chat/presentation/providers/chat_provider.dart';

/// [chatId]를 키로 사용하는 패밀리 AsyncNotifierProvider.
///
/// 채팅방마다 별도의 노티파이어 인스턴스를 생성합니다.
/// 예: `ref.watch(messagesProvider('chatId123'))`
final messagesProvider =
    AsyncNotifierProvider.family<MessagesNotifier, List<Message>, String>(
  MessagesNotifier.new,
);

/// 특정 채팅방의 메시지 목낅을 관리하는 FamilyAsyncNotifier.
///
/// - 페이지 단위 로드 ([loadMore])
/// - 메시지 전송 ([sendMessage])
class MessagesNotifier extends FamilyAsyncNotifier<List<Message>, String> {
  int _currentPage = 1;

  /// [arg]에 chatId가 주입됩니다. 리스트 첫 페이지를 가져옵니다.
  @override
  Future<List<Message>> build(String chatId) async {
    _currentPage = 1;
    return _fetchMessages(chatId);
  }

  Future<List<Message>> _fetchMessages(String chatId) async {
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.getMessages(chatId, page: _currentPage);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (messages) => messages,
    );
  }

  /// 이전 메시지 다음 페이지를 불러와 현재 리스트에 추가합니다.
  /// 실패 시 페이지 번호를 원래대로 돌립니다.
  Future<void> loadMore() async {
    final currentMessages = state.value ?? [];
    _currentPage++;
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.getMessages(arg, page: _currentPage);
    result.fold(
      (failure) => _currentPage--, // 실패 시 페이지 되돌리기
      (messages) {
        state = AsyncData([...currentMessages, ...messages]);
      },
    );
  }

  /// 메시지를 전송하고 성공 시 목록 맨 앞에 삽입합니다 (UI에서 새 메시지를 위에 표시 핵).
  Future<void> sendMessage(String content) async {
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.sendMessage(chatId: arg, content: content);
    result.fold(
      (failure) => null,
      (message) {
        final currentMessages = state.value ?? [];
        state = AsyncData([message, ...currentMessages]);
      },
    );
  }
}
