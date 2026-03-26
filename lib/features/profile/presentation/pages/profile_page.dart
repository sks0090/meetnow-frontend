import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';
import 'package:meetnow_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meetnow_frontend/features/profile/presentation/providers/profile_provider.dart';
import 'package:meetnow_frontend/shared/widgets/common_widgets.dart';

/// 내 프로필 페이지.
///
/// [myProfileProvider]를 구독하여 프로필 사진, 이름, 나이, 소개글, 관심사를 표시합니다.
/// 사진 그리드에서 마지막 아이템은 사진 입력(+) 버튼입니다.
/// 로그아웃 버튼은 authStateProvider.logout()을 호출합니다.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundImage: profile.photoUrls.isNotEmpty
                          ? NetworkImage(profile.photoUrls.first)
                          : null,
                      child: profile.photoUrls.isEmpty
                          ? const Icon(Icons.person, size: 56)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${profile.name}${profile.age != null ? ", ${profile.age}" : ""}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (profile.bio != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    profile.bio!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                '사진',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: profile.photoUrls.length + 1,
                itemBuilder: (context, index) {
                  if (index == profile.photoUrls.length) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.textHint,
                        size: 32,
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      profile.photoUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (profile.interests.isNotEmpty) ...[
                const Text(
                  '관심사',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.interests
                      .map((interest) => Chip(
                            label: Text(interest),
                            backgroundColor:
                                AppColors.primaryLight.withValues(alpha: 0.2),
                            labelStyle:
                                const TextStyle(color: AppColors.primary),
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],
              OutlinedButton(
                onPressed: () => ref.read(authStateProvider.notifier).logout(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('로그아웃'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorRetryWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(myProfileProvider),
        ),
      ),
    );
  }
}
