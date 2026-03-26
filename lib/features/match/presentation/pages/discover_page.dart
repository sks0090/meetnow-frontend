import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';
import 'package:meetnow_frontend/features/match/presentation/providers/match_provider.dart';
import 'package:meetnow_frontend/shared/widgets/common_widgets.dart';

/// 탐색(Discover) 페이지.
///
/// [discoverProfilesProvider]를 구독하여 커드 형태의 프로필을 표시합니다.
/// 커드 카드는 항상 첫 번째 프로필([profiles.first])이 보이며,
/// 좋아요/싫어요 시 해당 프로필이 목록에서 제거됩니다.
/// 좋아요가 매칭이 되면 SnackBar로 충에 알림이 표시됩니다.
class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(discoverProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MeetNow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // TODO: Open filter settings
            },
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.explore,
              title: '주변에 새로운 프로필이 없어요',
              subtitle: '나중에 다시 확인해보세요!',
            );
          }

          final profile = profiles.first;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (profile.photoUrls.isNotEmpty)
                          Image.network(
                            profile.photoUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.background,
                              child: const Icon(
                                Icons.person,
                                size: 100,
                                color: AppColors.textHint,
                              ),
                            ),
                          )
                        else
                          Container(
                            color: AppColors.background,
                            child: const Icon(
                              Icons.person,
                              size: 100,
                              color: AppColors.textHint,
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${profile.name}, ${profile.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (profile.bio != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    profile.bio!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (profile.distance != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${profile.distance!.toStringAsFixed(1)}km 거리',
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      icon: Icons.close,
                      color: AppColors.nope,
                      size: 60,
                      onPressed: () {
                        ref
                            .read(discoverProfilesProvider.notifier)
                            .dislikeProfile(profile.id);
                      },
                    ),
                    _ActionButton(
                      icon: Icons.star,
                      color: AppColors.superLike,
                      size: 48,
                      onPressed: () {
                        // TODO: Super like
                      },
                    ),
                    _ActionButton(
                      icon: Icons.favorite,
                      color: AppColors.like,
                      size: 60,
                      onPressed: () async {
                        final isMatch = await ref
                            .read(discoverProfilesProvider.notifier)
                            .likeProfile(profile.id);
                        if (isMatch && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('매칭 성공! 🎉'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorRetryWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(discoverProfilesProvider),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: color, size: size * 0.5),
        ),
      ),
    );
  }
}
