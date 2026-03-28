import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';
import 'package:meetnow_frontend/features/chat/domain/entities/message.dart';
import 'package:meetnow_frontend/features/chat/presentation/providers/chat_provider.dart';

/// [chatId]를 키로 사용하는 패밀리 AsyncNotifierProvider.
///
/// autoDispose를 적용하여 채팅방 이탈 시 WebSocket 구독을 자동 해제합니다.
/// 예: `ref.watch(messagesProvider('chatId123'))`
final messagesProvider = AsyncNotifierProvider.family
    .autoDispose<MessagesNotifier, List<Message>, String>(
  MessagesNotifier.new,
);

/// 특정 채팅방의 메시지 목록을 관리하는 AutoDisposeFamilyAsyncNotifier.
///
/// - 페이지 단위 로드 ([loadMore])
/// - 메시지 전송 ([sendMessage])
/// - 채팅방 입장 시 WebSocket 구독, 이탈 시 자동 해제
class MessagesNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Message>, String> {
  int _currentPage = 1;

  /// [arg]에 chatId가 주입됩니다. 리스트 첫 페이지를 가져오고 WebSocket을 구독합니다.
  @override
  Future<List<Message>> build(String chatId) async {
    _currentPage = 1;

    // WebSocket 구독: 새 메시지 실시간 수신
    final subscription = ref
        .read(chatRepositoryProvider)
        .subscribeToMessages(chatId)
        .listen((message) {
      appLogger.d('[Chat] 실시간 메시지 수신: ${message.id}');
      final current = state.value ?? [];
      state = AsyncData([message, ...current]);
    });

    // 채팅방 이탈(dispose) 시 WebSocket 구독 해제
    ref.onDispose(() {
      appLogger.i('[Chat] WebSocket 구독 해제: chatId=$chatId');
      subscription.cancel();
    });

    return _fetchMessages(chatId);
  }

  Future<List<Message>> _fetchMessages(String chatId) async {
    appLogger.i('[Chat] 메시지 로드: chatId=$chatId, page=$_currentPage');
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.getMessages(chatId, page: _currentPage);
    return result.fold(
      (failure) {
        appLogger.w('[Chat] 메시지 로드 실패: ${failure.message}');
        throw Exception(failure.message);
      },
      (messages) {
        appLogger.i('[Chat] 메시지 ${messages.length}개 로드 완료');
        return messages;
      },
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
    appLogger.i('[Chat] 메시지 전송: chatId=$arg');
    final repo = ref.read(chatRepositoryProvider);
    final result = await repo.sendMessage(chatId: arg, content: content);
    result.fold(
      (failure) => appLogger.w('[Chat] 메시지 전송 실패: ${failure.message}'),
      (message) {
        appLogger.d('[Chat] 메시지 전송 성공: ${message.id}');
        final currentMessages = state.value ?? [];
        state = AsyncData([message, ...currentMessages]);
      },
    );
  }
}
