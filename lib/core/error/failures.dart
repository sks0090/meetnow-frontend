import 'package:fpdart/fpdart.dart';

/// 유스케이스/Repository의 응답을 표현하는 타입 유틸리티.
///
/// 예시: `ResultFuture<User>` = `Future<Either<Failure, User>>`
/// 성공 시 Right(value), 실패 시 Left(Failure)를 반환합니다.
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// 반환값이 없이 성공/실패 여부만 필요할 때 사용하는 타입 유틸리티.
typedef ResultVoid = ResultFuture<void>;

/// 도메인 레이어에서 사용되는 실패 타입의 최상위 sealed 클래스.
///
/// [Either]<Failure, T>에서 Left 측에 위치합니다.
/// sealed로 선언되어 있어 switch 표현식으로 모든 케이스를 처리할 수 있습니다.
sealed class Failure {
  final String message;

  /// HTTP 상태 코드 (서버 오류인 경우만 존재).
  final int? statusCode;

  const Failure({required this.message, this.statusCode});
}

/// 서버가 오류 응답을 내린 때 (4xx/5xx HTTP 상태코드 등).
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// 로컬 캐시(SharedPreferences, SecureStorage, 로컬 DB)에서 발생한 오류.
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// 네트워크 연결 실패 (오프라인, 타임아웃 등).
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = '네트워크 연결을 확인해주세요.'});
}

/// 인증 실패 (토큰 만료, 권한 없음 등).
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

/// 입력값 검증 실패. [fieldErrors]에 필드별 오류 메시지를 담을 수 있습니다.
class ValidationFailure extends Failure {
  /// 키: 필드명, 값: 해당 필드의 오류 메시지 목록.
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
  });
}
