import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';
import 'package:meetnow_frontend/core/network/api_client.dart';
import 'package:meetnow_frontend/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:meetnow_frontend/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:meetnow_frontend/features/profile/domain/entities/profile.dart';
import 'package:meetnow_frontend/features/profile/domain/repositories/profile_repository.dart';

/// [ProfileRepository] 인스턴스를 제공하는 Provider.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRepositoryImpl(ProfileRemoteDataSourceImpl(dio));
});

/// 내 프로필 상태를 관리하는 AsyncNotifierProvider.
final myProfileProvider =
    AsyncNotifierProvider<MyProfileNotifier, Profile>(MyProfileNotifier.new);

/// 로그인한 사용자 자신의 프로필 상태를 관리하는 AsyncNotifier.
///
/// 프로필 수정([updateProfile]) 및 사진 업로드([uploadPhoto])를 지원합니다.
class MyProfileNotifier extends AsyncNotifier<Profile> {
  /// 빌드 시 서버에서 내 프로필을 가져옵니다.
  @override
  Future<Profile> build() => _fetchProfile();

  Future<Profile> _fetchProfile() async {
    appLogger.i('[Profile] 내 프로필 로드 중...');
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.getMyProfile();
    return result.fold(
      (failure) {
        appLogger.w('[Profile] 프로필 로드 실패: ${failure.message}');
        throw Exception(failure.message);
      },
      (profile) {
        appLogger.i('[Profile] 프로필 로드 성공: userId=${profile.id}');
        return profile;
      },
    );
  }

  /// 프로필 정보를 부분 수정합니다. null인 필드는 변경하지 않습니다.
  Future<void> updateProfile({
    String? name,
    String? bio,
    int? age,
    String? gender,
    List<String>? interests,
  }) async {
    appLogger.i('[Profile] 프로필 수정 요청');
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.updateProfile(
      name: name,
      bio: bio,
      age: age,
      gender: gender,
      interests: interests,
    );
    result.fold(
      (failure) => appLogger.w('[Profile] 프로필 수정 실패: ${failure.message}'),
      (profile) {
        appLogger.i('[Profile] 프로필 수정 성공');
        state = AsyncData(profile);
      },
    );
  }

  /// 사진을 업로드합니다. 성공 시 서버에서 최신 프로필을 다시 가져옵니다.
  Future<void> uploadPhoto(String filePath) async {
    appLogger.i('[Profile] 사진 업로드: $filePath');
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.uploadPhoto(filePath);
    result.fold(
      (failure) => appLogger.w('[Profile] 사진 업로드 실패: ${failure.message}'),
      (_) async {
        appLogger.i('[Profile] 사진 업로드 성공 → 프로필 재로드');
        // 업로드 후 photoUrls 목록이 바뀌므로 프로필 전체 재로드
        state = await AsyncValue.guard(() => _fetchProfile());
      },
    );
  }
}
