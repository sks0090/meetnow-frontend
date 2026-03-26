import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meetnow_frontend/core/network/api_client.dart';
import 'package:meetnow_frontend/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:meetnow_frontend/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:meetnow_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meetnow_frontend/features/auth/domain/entities/user.dart';
import 'package:meetnow_frontend/features/auth/domain/repositories/auth_repository.dart';

// ── 내부 의존성 Provider (private) ──────────────────────────────────────────

/// 원격 인증 데이터소스 Provider. [dioProvider]를 주입받아 생성합니다.
final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

/// 로컬 인증 데이터소스 Provider. [FlutterSecureStorage]를 사용합니다.
final _authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return const AuthLocalDataSourceImpl(FlutterSecureStorage());
});

// ── 공개 Repository Provider ──────────────────────────────────────────────────

/// [AuthRepository] 인스턴스를 제공하는 Provider.
/// 원격/로컬 데이터소스를 의존성 주입합니다.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(_authRemoteDataSourceProvider),
    ref.watch(_authLocalDataSourceProvider),
  );
});

// ── 인증 상태 Provider ────────────────────────────────────────────────────────

/// 현재 로그인된 [User]를 관리하는 AsyncNotifierProvider.
///
/// - `null`: 비로그인 상태
/// - `User 인스턴스`: 로그인 완료 상태
/// - 이 Provider를 [routerProvider]가 구독하여 인증 리다이렉트를 처리합니다.
final authStateProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

/// 인증 상태(로그인/로그아웃)를 관리하는 AsyncNotifier.
///
/// [build]에서 앱 시작 시 로컬 토큰이 있으면 서버에서 사용자 정보를 가져옵니다.
class AuthNotifier extends AsyncNotifier<User?> {
  /// 앱 초기화 시 호출됩니다.
  /// 로컬에 토큰이 있으면 서버에서 현재 사용자 정보를 가져옵니다.
  @override
  Future<User?> build() async {
    final repo = ref.read(authRepositoryProvider);
    final isLoggedIn = await repo.isLoggedIn();
    if (!isLoggedIn) return null;

    // fold: Left(실패) → null 반환, Right(성공) → User 반환
    final result = await repo.getCurrentUser();
    return result.fold((failure) => null, (user) => user);
  }

  /// 이메일/비밀번호로 로그인합니다.
  /// 성공 시 state가 [AsyncData(User)]로, 실패 시 [AsyncError]로 변경됩니다.
  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(email: email, password: password);
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  /// 신규 회원가입 후 자동 로그인합니다.
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signup(
      name: name,
      email: email,
      password: password,
    );
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  /// 로그아웃합니다. state를 [AsyncData(null)]로 설정해 비로그인 상태로 만듭니다.
  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(null); // 라우터 리다이렉트가 이 변경을 감지해 login 페이지로 이동
  }
}
