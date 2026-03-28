import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meetnow_frontend/app/router/app_router.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';
import 'package:meetnow_frontend/features/splash/presentation/providers/splash_init_provider.dart';

/// 스플래시 페이지.
///
/// 앱 아이콘의 "MN"이 "MeetNow"로 펼쳐지는 애니메이션을 보여주며,
/// 동시에 백그라운드 초기화(토큰 검증, 설정 로드 등)를 병렬로 수행합니다.
/// 애니메이션과 초기화가 **모두 완료**된 후 다음 화면으로 이동합니다.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _subtitleAnimation;
  bool _animationDone = false;
  bool _initDone = false;

  static const _textStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.5,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // 0.0 ~ 0.30 : "MN" 유지
    // 0.30 ~ 0.65 : "MN" → "MeetNow" 펼침
    // 0.55 ~ 0.75 : 서브타이틀 페이드인
    // 0.75 ~ 1.0  : 잠시 유지 후 이동
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
    );

    _subtitleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.75, curve: Curves.easeIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationDone = true;
        _navigateIfReady();
      }
    });

    _controller.forward();

    // 백그라운드 초기화 구독 (fireImmediately: 이미 완료된 상태도 즉시 수신)
    ref.listenManual(splashInitProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          _initDone = true;
          _navigateIfReady();
        },
        error: (error, _) {
          // 초기화 실패 시에도 로그인으로 이동 (로그인에서 재시도 가능)
          _initDone = true;
          _navigateIfReady();
        },
      );
    }, fireImmediately: true);
  }

  void _navigateIfReady() {
    if (_animationDone && _initDone && mounted) {
      context.go(AppRoutes.discover);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, _) {
                final t = _expandAnimation.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "M" — 항상 표시
                    Text(
                      'M',
                      style: _textStyle.copyWith(color: AppColors.primary),
                    ),
                    // "eet" — 너비 0 → 전체로 펼쳐짐
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: t,
                        child: Text(
                          'eet',
                          style: _textStyle.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    // "N" — 항상 표시
                    Text(
                      'N',
                      style: _textStyle.copyWith(color: Colors.black),
                    ),
                    // "ow" — 너비 0 → 전체로 펼쳐짐
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: t,
                        child: Text(
                          'ow',
                          style: _textStyle.copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _subtitleAnimation,
              child: const Text(
                '새로운 만남을 시작하세요',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
