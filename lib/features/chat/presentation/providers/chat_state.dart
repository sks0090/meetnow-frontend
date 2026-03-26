import 'package:meetnow_frontend/features/chat/domain/entities/chat.dart';

// 주의: 이 파일은 레거시 상태 클래스입니다.
// 현재 앱은 chat_provider.dart에서 AsyncNotifier 패턴을 사용하며,
// 이 ChatListState는 직접 사용되지 않습니다.

/// 채팅 목록 상태 클래스 (legacy).
class ChatListState {
  final List<Chat> chats;
  final bool isLoading;
  final String? error;

  const ChatListState({
    this.chats = const [],
    this.isLoading = false,
    this.error,
  });

  ChatListState copyWith({
    List<Chat>? chats,
    bool? isLoading,
    String? error,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
