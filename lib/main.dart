import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetnow_frontend/app/app.dart';
import 'package:meetnow_frontend/app/config/env.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';
import 'package:meetnow_frontend/shared/providers/storage_providers.dart';

/// 앱의 진입점(entry point).
///
/// Flutter 엔진 초기화 → 환경 설정 → SharedPreferences 로드 → Riverpod ProviderScope로 앱 실행
/// 순서대로 초기화가 이루어집니다.
void main() async {
  // Flutter 엔진 바인딩을 초기화합니다. async main에서 반드시 먼저 호출해야 합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // 현재 실행 환경을 dev(개발)로 설정합니다.
  // 배포 시에는 Environment.prod로 변경하세요.
  Env.init(Environment.dev);
  appLogger.i('[App] 환경 초기화 완료: ${Env.currentEnv}');

  // SharedPreferences는 비동기로 초기화되므로 미리 인스턴스를 가져온 뒤
  // Provider에 주입합니다.
  final sharedPreferences = await SharedPreferences.getInstance();
  appLogger.i('[App] SharedPreferences 로드 완료');

  runApp(
    // ProviderScope: Riverpod의 모든 Provider를 이 위젯 트리에서 관리합니다.
    ProviderScope(
      overrides: [
        // SharedPreferences 인스턴스를 Provider에 미리 주입합니다.
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MeetNowApp(),
    ),
  );
}
