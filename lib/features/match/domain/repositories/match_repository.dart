import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/match/domain/entities/match_profile.dart';

/// 매칭 관련 데이터 조작의 계약(Contract).
abstract class MatchRepository {
  /// 탐색(Discover) 화면에 표시할 프로필 목록을 가져옵니다.
  ResultFuture<List<MatchProfile>> getDiscoverProfiles();

  /// [profileId]에 좋아요를 누릅니다.
  /// 상대방도 좋아요를 눌렀다면 true(매칭 성사), 아니면 false를 반환합니다.
  ResultFuture<bool> likeProfile(String profileId);

  /// [profileId]에 싫어요를 누릅니다.
  ResultFuture<void> dislikeProfile(String profileId);
}
