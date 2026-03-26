import 'package:dio/dio.dart';
import 'package:meetnow_frontend/core/error/exceptions.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';

/// [DioException]을 앱의 정의된 예외 클래스로 변환하는 Dio 인터섭터.
///
/// [ErrorInterceptor.onError]를 통해:
/// - 타임아웃 → [ServerException]
/// - 커넥션 오류 → [ServerException]
/// - 401 → [UnauthorizedException]
/// - 404 → [NotFoundException]
/// - 기타 → [ServerException]
///
/// Repository 구현체에서는 이 예외들을 catch해 [Failure]로 매핑합니다.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 에러 내용을 로그에 기록합니다.
    appLogger.e('API Error', error: err);

    switch (err.type) {
      // 네트워크 타임아웃 종류 ──────────────────────────────────────────────────
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ServerException(
          message: '서버 응답 시간이 초과되었습니다.',
          statusCode: err.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        throw const ServerException(message: '서버에 연결할 수 없습니다.');
      default:
        // HTTP 상태 코드에 따라 적절한 예외로 변환합니다.
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        // 서버가 JSON으로 `message` 필드를 내려주는 경우 채웁니다.
        final message = data is Map ? data['message'] as String? : null;

        if (statusCode == 401) {
          throw UnauthorizedException(
            message: message ?? '인증이 만료되었습니다.',
          );
        }
        if (statusCode == 404) {
          throw NotFoundException(
            message: message ?? '리소스를 찾을 수 없습니다.',
          );
        }

        throw ServerException(
          message: message ?? '알 수 없는 오류가 발생했습니다.',
          statusCode: statusCode,
        );
    }
  }
}
