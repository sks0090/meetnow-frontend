import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/auth/domain/entities/user.dart';
import 'package:meetnow_frontend/features/auth/domain/repositories/auth_repository.dart';

/// 로그인 비즈니스 로직을 수행하는 유스케이스.
///
/// Clean Architecture에서 유스케이스는 하나의 작업만 수행합니다.
/// Presenter는 Repository를 직접 호출하지 않고 유스케이스를 통해 데이터를 요청합니다.
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  /// [email]과 [password]로 로그인을 시도합니다.
  /// 성공 시 [User]를, 실패 시 [Failure]를 [Either]로 반환합니다.
  ResultFuture<User> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
