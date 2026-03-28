import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meetnow_frontend/core/constants/app_constants.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';

/// 모든 HTTP 요청에 인증 토큰을 자동으로 주입하는 Dio 인터섭터.
///
/// 1. [onRequest]: [FlutterSecureStorage]에서 액세스 토큰을 읽어
///    `Authorization: Bearer <token>` 헤더를 수동으로 추가하지 않아도 자동
///    동작합니다.
/// 2. [onError]: 401 상태코드 수신 시 토큰 갱신 로직을 여기에 구현할 수 있습니다.
class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  /// 요청 직전에 호출됩니다. 토큰이 존재하면 [RequestOptions.headers]에 주입합니다.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: AppConstants.accessTokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    appLogger.d('[HTTP] ${options.method} ${options.uri}');
    handler.next(options); // 다음 인터셉터 또는 실제 요청으로 진행
  }

  /// HTTP 401 좌시 키퍼 만료 처리를 담당합니다.
  /// TODO: 리프레시 토큰으로 새 토큰을 발급망으로 요청을 재시도하는 로직을 구현하세요.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token refresh logic can be added here
    }
    handler.next(err);
  }
}
