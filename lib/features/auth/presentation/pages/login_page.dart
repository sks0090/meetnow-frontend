import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';
import 'package:meetnow_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meetnow_frontend/features/auth/presentation/widgets/social_login_button.dart';
import 'package:meetnow_frontend/features/auth/data/services/social_login_service.dart';

/// 로그인 페이지.
///
/// 이메일 로그인 없이 소셜 로그인만 제공합니다.
/// - iOS: 카카오톡 + Apple 로그인
/// - Android: 카카오톡 + Google 로그인
///
/// [authStateProvider]를 ref.listen으로 구독하여 에러 시
/// SnackBar로 사용자에게 안내합니다.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // 'Meet'는 primary 색상, 'Now'는 검정색으로 구분합니다.
              Text.rich(
                const TextSpan(
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Meet',
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'Now',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '새로운 만남을 시작하세요',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // 카카오톡 로그인 (공통) — 카카오 브랜드 색상(노란색)
              SocialLoginButton(
                icon: Icons.chat_bubble,
                label: '카카오톡으로 시작하기',
                backgroundColor: const Color(0xFFFEE500),
                foregroundColor: const Color(0xFF191919),
                onPressed: () => _loginWith(ref, () {
                  return ref.read(socialLoginServiceProvider).loginWithKakao();
                }),
              ),
              const SizedBox(height: 12),
              // iOS → Apple 로그인(검정), Android → Google 로그인(검정)
              if (Platform.isIOS)
                SocialLoginButton(
                  icon: Icons.apple,
                  label: 'Apple로 시작하기',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onPressed: () => _loginWith(ref, () {
                    return ref
                        .read(socialLoginServiceProvider)
                        .loginWithApple();
                  }),
                )
              else
                SocialLoginButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google로 시작하기',
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onPressed: () => _loginWith(ref, () {
                    return ref
                        .read(socialLoginServiceProvider)
                        .loginWithGoogle();
                  }),
                ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  /// 소셜 SDK에서 토큰을 받아 서버에 로그인 요청을 보냅니다.
  Future<void> _loginWith(
    WidgetRef ref,
    Future<SocialLoginResult> Function() getSocialToken,
  ) async {
    try {
      final result = await getSocialToken();
      await ref.read(authStateProvider.notifier).loginWithSocial(
            provider: result.provider,
            token: result.token,
          );
    } catch (e) {
      // SDK 에러(취소 등)는 authStateProvider 에러와 별개로 처리
      // authStateProvider의 listen이 SnackBar를 표시하지 못하는 경우 대비
      if (e.toString().contains('취소')) return; // 사용자 취소는 무시
      rethrow; // 나머지 에러는 상위로 전파 → ref.listen이 처리
    }
  }
}
