import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetnow_frontend/core/logger/app_logger.dart';
import 'package:meetnow_frontend/core/network/api_client.dart';
import 'package:meetnow_frontend/features/match/data/datasource/match_remote_datasource.dart';
import 'package:meetnow_frontend/features/match/data/repositories/match_repository_impl.dart';
import 'package:meetnow_frontend/features/match/domain/entities/match_profile.dart';
import 'package:meetnow_frontend/features/match/domain/repositories/match_repository.dart';

/// [MatchRepository] 인스턴스를 제공하는 Provider.
final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MatchRepositoryImpl(MatchRemoteDataSourceImpl(dio));
});

/// 탐색(Discover) 화면에서 보여줄 프로필 목록을 관리하는 AsyncNotifierProvider.
///
/// autoDispose + keepAlive(5분)로 탭 전환 시 스와이프 덱 상태를 유지합니다.
final discoverProfilesProvider =
    AsyncNotifierProvider.autoDispose<DiscoverNotifier, List<MatchProfile>>(
  DiscoverNotifier.new,
);

/// 스와이프 카드 덱의 프로필 목록 상태를 관리하는 AutoDisposeAsyncNotifier.
///
/// 좋아요/싫어요 시 해당 프로필을 제거하고,
/// 남은 프로필이 3개 미만이면 다음 배치를 자동으로 불러옵니다.
/// keepAlive(5분)로 탭 전환 시 현재 덱 상태를 유지합니다.
class DiscoverNotifier extends AutoDisposeAsyncNotifier<List<MatchProfile>> {
  @override
  Future<List<MatchProfile>> build() {
    // 탭 이동 후 재진입 시 덱 상태 유지 (5분간 캐시)
    final link = ref.keepAlive();
    Timer(const Duration(minutes: 5), link.close);

    return _fetchProfiles();
  }

  Future<List<MatchProfile>> _fetchProfiles() async {
    appLogger.i('[Match] 탐색 프로필 목록 로드 중...');
    final repo = ref.read(matchRepositoryProvider);
    final result = await repo.getDiscoverProfiles();
    return result.fold(
      (failure) {
        appLogger.w('[Match] 프로필 로드 실패: ${failure.message}');
        throw Exception(failure.message);
      },
      (profiles) {
        appLogger.i('[Match] 프로필 ${profiles.length}개 로드 완료');
        return profiles;
      },
    );
  }

  /// 특정 프로필에 좋아요를 누릅니다.
  /// 매칭이 성사되면 true, 아니면 false를 반환합니다.
  Future<bool> likeProfile(String profileId) async {
    appLogger.i('[Match] 좋아요: $profileId');
    final repo = ref.read(matchRepositoryProvider);
    final result = await repo.likeProfile(profileId);
    return result.fold(
      (failure) {
        appLogger.w('[Match] 좋아요 실패: ${failure.message}');
        return false;
      },
      (isMatch) {
        if (isMatch) appLogger.i('[Match] 매칭 성사! profileId=$profileId');
        _removeTopProfile();
        return isMatch;
      },
    );
  }

  /// 특정 프로필에 싫어요를 누릅니다.
  Future<void> dislikeProfile(String profileId) async {
    appLogger.i('[Match] 싫어요: $profileId');
    final repo = ref.read(matchRepositoryProvider);
    await repo.dislikeProfile(profileId);
    _removeTopProfile();
  }

  /// 덱의 첫 번째 프로필을 제거합니다.
  /// 남은 개수가 3개 미만이 되면 다음 배치를 미리 가져옵니다.
  void _removeTopProfile() {
    final current = state.value ?? [];
    if (current.isNotEmpty) {
      state = AsyncData(current.sublist(1));
    }
    // 남은 프로필이 3개 미만이면 자동으로 다음 배치 로드
    if ((state.value ?? []).length < 3) {
      _fetchProfiles().then((profiles) {
        final current = state.value ?? [];
        state = AsyncData([...current, ...profiles]);
      });
    }
  }
}
