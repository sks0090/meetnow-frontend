import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';
import 'package:meetnow_frontend/features/chat/presentation/providers/chat_provider.dart';
import 'package:meetnow_frontend/shared/widgets/common_widgets.dart';

/// 채팅 목록 페이지.
///
/// [chatListProvider]를 구독하여 반환된 [Chat] 목록을 ListView로 표시합니다.
/// 읽지 않은 메시지가 있는 채팅은 말풍선 배지로 표시됩니다.
class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsync = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: chatListAsync.when(
        data: (chats) {
          if (chats.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: '아직 매칭된 대화가 없어요',
              subtitle: '새로운 사람들을 탐색해보세요!',
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(chatListProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: chat.participantAvatarUrl != null
                        ? NetworkImage(chat.participantAvatarUrl!)
                        : null,
                    child: chat.participantAvatarUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    chat.participantName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    chat.lastMessage?.content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: chat.unreadCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : null,
                  onTap: () => context.push('/chats/${chat.id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorRetryWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(chatListProvider),
        ),
      ),
    );
  }
}
