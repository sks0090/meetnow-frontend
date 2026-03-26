import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/auth/domain/repositories/auth_repository.dart';

/// 쓰러진 액세스 토큰을 리프레시 토큰으로 갱신하는 유스케이스.
///
/// [AuthInterceptor]에서 401 에러를 받았을 때 호출합니다.
class RefreshTokenUseCase {
  final AuthRepository _repository;

  const RefreshTokenUseCase(this._repository);

  /// 토큰 갱신을 실행합니다. 리프레시 토큰이 없으면 [AuthFailure]를 반환합니다.
  ResultVoid call() => _repository.refreshToken();
}
