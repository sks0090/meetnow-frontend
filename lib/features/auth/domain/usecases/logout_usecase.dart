import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/auth/domain/repositories/auth_repository.dart';

/// 로그아웃 비즈니스 로직을 수행하는 유스케이스.
///
/// 서버에 로그아웃을 요청하고 로컬에 저장된 인증 토큰을 삭제합니다.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  /// 로그아웃을 실행합니다.
  /// 성공 시 [Right(null)], 실패 시 [Left(Failure)]를 반환합니다.
  ResultVoid call() => _repository.logout();
}
