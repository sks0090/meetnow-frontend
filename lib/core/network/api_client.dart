import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/app/config/env.dart';
import 'package:meetnow_frontend/core/constants/app_constants.dart';
import 'package:meetnow_frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:meetnow_frontend/core/network/interceptors/error_interceptor.dart';

/// 앱의 HTTP 클라이언트 [Dio] 인스턴스를 제공하는 Riverpod Provider.
///
/// 모든 API 요청에 공통으로 적용되는 설정(기본 URL, 타임아웃, 헤더)으로
/// 초기화되며, 아래의 인터셈터를 순서대로 적용합니다:
/// 1. [AuthInterceptor]  — 요청에 Bearer 토큰을 주입
/// 2. [ErrorInterceptor] — DioException을 앱 예외로 변환
/// 3. [LogInterceptor]   — 개발 환경에서만 활성화되는 요청/응답 로깅
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(), // 1) 요청 헤더에 토큰 주입
    ErrorInterceptor(), // 2) 네트워크 예외 매핑
    // 개발 실행 시에만 요청/응답 내용을 콘솔에 출력합니다.
    if (Env.isDev) LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
});
