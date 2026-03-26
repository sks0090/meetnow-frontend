// 데이터 레이어(datasource)에서 발생하는 예외 클래스 모음.
//
// 데이터 레이어에서 throw하고, Repository 구현체에서 catch한 후
// [Failure]로 변환하는 패턴으로 사용합니다.

/// 서버가 오류 응답을 내릴 때 (예: 4xx, 5xx 상태 코드).
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

/// 로컬 캐시(SharedPreferences, SecureStorage)에서 발생한 예외.
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});
}

/// HTTP 401이거나 토큰이 유효하지 않을 때 발생하는 예외.
/// [AuthInterceptor]에서 throw합니다.
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = '인증이 만료되었습니다.'});
}

/// 요청한 리소스를 찾을 수 없을 때 (HTTP 404) 발생하는 예외.
class NotFoundException implements Exception {
  final String message;

  const NotFoundException({this.message = '리소스를 찾을 수 없습니다.'});
}
