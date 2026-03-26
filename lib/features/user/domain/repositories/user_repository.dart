import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/user/domain/entities/user_profile.dart';

/// 다른 사용자 조회/신고/차단 관련 계약(Contract).
abstract class UserRepository {
  /// [userId]에 해당하는 공개 프로필을 가져옵니다.
  ResultFuture<UserProfile> getUserProfile(String userId);

  /// [userId]를 [reason]으로 신고합니다.
  ResultFuture<void> reportUser(String userId, String reason);

  /// [userId]를 차단합니다. 차단된 사용자는 탐색에서 나타나지 않습니다.
  ResultFuture<void> blockUser(String userId);
}
