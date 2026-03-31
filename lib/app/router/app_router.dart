import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';
import 'package:meetnow_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:meetnow_frontend/features/splash/presentation/pages/splash_page.dart';
import 'package:meetnow_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:meetnow_frontend/features/chat/presentation/pages/chat_list_page.dart';
import 'package:meetnow_frontend/features/chat/presentation/pages/chat_page.dart';
import 'package:meetnow_frontend/features/match/presentation/pages/discover_page.dart';
import 'package:meetnow_frontend/features/profile/presentation/pages/profile_page.dart';
import 'package:meetnow_frontend/shared/widgets/main_scaffold.dart';

/// 앱 내 모든 라우트 경로 상수를 정의합니다.
///
/// 문자열을 직접 사용하는 대신 이 클래스의 상수를 참조해 오타를 방지합니다.
abstract class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String discover = '/discover'; // 메인 탭 1: 상대방 탐색
  static const String matches = '/matches'; // 매칭된 상대방 목록
  static const String chatList = '/chats'; // 메인 탭 2: 채팅 목록
  static const String chat = '/chats/:chatId'; // 개별 채팅방
  static const String profile = '/profile'; // 메인 탭 3: 내 프로필
}

/// GoRouter 인스턴스를 제공하는 Riverpod Provider.
///
/// [authStateProvider]를 구독하여 로그인 상태가 바뀔 때마다 라우터의
/// redirect 조건이 자동으로 재평가됩니다.
final routerProvider = Provider<GoRouter>((ref) {
  // 인증 상태를 감시합니다. 로그인/로그아웃 시 redirect가 다시 실행됩니다.
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    // 모든 내비게이션 직전에 실행되는 리다이렉트 로직.
    redirect: (context, state) {
      // 스플래시 페이지는 리다이렉트하지 않음 (애니메이션 완료 후 자체 이동)
      if (state.matchedLocation == AppRoutes.splash) return null;

      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login;

      // 비로그인 상태에서 인증 페이지 외 접근 시 → 로그인 화면으로
      if (!isLoggedIn && !isAuthRoute) {
        appLogger
            .d('[Router] 비로그인 → ${state.matchedLocation}에서 /login으로 리다이렉트');
        return AppRoutes.login;
      }
      // 이미 로그인된 상태에서 인증 페이지 접근 시 → 탐색 화면으로
      if (isLoggedIn && isAuthRoute) {
        appLogger
            .d('[Router] 로그인 완료 → ${state.matchedLocation}에서 /discover로 리다이렉트');
        return AppRoutes.discover;
      }
      return null; // 리다이렉트 없이 원래 경로로 이동
    },
    routes: [
      // 스플래시 (MN → MeetNow 애니메이션)
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      // 인증 라우트 (하단 탭 바 없음) — splash에서 페이드 전환
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoginPage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // 메인 화면: StatefulShellRoute로 하단 탭 3개를 독립된 내비게이션 스택으로 관리합니다.
      // indexedStack 방식은 탭 전환 시 상태를 유지합니다.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // 탭 0: 탐색 (상대방 카드 스와이프)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          // 탭 1: 채팅 목록 → 개별 채팅방 (중첩 라우트)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chatList,
                builder: (context, state) => const ChatListPage(),
                routes: [
                  // 하위 경로: /chats/:chatId
                  GoRoute(
                    path: ':chatId',
                    builder: (context, state) => ChatPage(
                      chatId: state.pathParameters['chatId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 탭 2: 내 프로필
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
