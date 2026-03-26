import 'package:meetnow_frontend/features/auth/domain/entities/user.dart';

// 주의: 이 파일은 레거시 상태 클래스입니다.
// 현재 앱은 auth_provider.dart에서 AsyncNotifier 패턴을 사용하며,
// 이 AuthState/AuthStatus는 직접 사용되지 않습니다.

/// 인증 상태를 나타내는 열거형 (legacy).
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// 인증 상태를 담는 클래스 (legacy).
/// 현재는 auth_provider.dart의 AsyncValue<User?> 로 대체되어 있습니다.
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}
