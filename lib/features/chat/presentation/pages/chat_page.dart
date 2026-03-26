import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';
import 'package:meetnow_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meetnow_frontend/features/chat/presentation/providers/message_provider.dart';
import 'package:meetnow_frontend/features/chat/presentation/widgets/chat_input.dart';
import 'package:meetnow_frontend/shared/widgets/common_widgets.dart';

/// 1:1 채팅 페이지.
///
/// [messagesProvider(chatId)]를 구독하여 메시지 목록을 표시합니다.
/// 내가 보낸 메시지(isMe)는 오른쪽, 상대방 메시지는 왼쪽에 정렬됩니다.
/// [ChatInput] 위젯에서 메시지를 입력하면 sendMessage를 호출합니다.
class ChatPage extends ConsumerWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider(chatId));
    final currentUser = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.chat,
                    title: '첫 메시지를 보내보세요!',
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser?.id;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorRetryWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(messagesProvider(chatId)),
              ),
            ),
          ),
          ChatInput(
            onSend: (content) {
              ref.read(messagesProvider(chatId).notifier).sendMessage(content);
            },
          ),
        ],
      ),
    );
  }
}
