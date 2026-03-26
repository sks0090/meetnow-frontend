import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/app/router/app_router.dart';
import 'package:meetnow_frontend/app/theme/app_theme.dart';
import 'package:meetnow_frontend/core/constants/app_constants.dart';

/// 앱의 루트 위젯.
///
/// [ConsumerWidget]을 상속하여 Riverpod의 [routerProvider]를 구독합니다.
/// 테마와 라우터 설정을 적용한 [MaterialApp.router]를 반환합니다.
class MeetNowApp extends ConsumerWidget {
  const MeetNowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // routerProvider가 변경될 때마다 라우터를 갱신합니다.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
