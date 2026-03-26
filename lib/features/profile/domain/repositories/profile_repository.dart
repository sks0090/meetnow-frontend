import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/profile/domain/entities/profile.dart';

/// 내 프로필 관련 데이터 조작의 계약(Contract).
abstract class ProfileRepository {
  /// 내 프로필을 가져옵니다.
  ResultFuture<Profile> getMyProfile();

  /// 프로필 정보를 수정합니다. null인 필드는 변경되지 않습니다.
  ResultFuture<Profile> updateProfile({
    String? name,
    String? bio,
    int? age,
    String? gender,
    List<String>? interests,
  });

  /// 사진을 업로드하고 URL을 반환합니다.
  ResultFuture<String> uploadPhoto(String filePath);

  /// [photoId]에 해당하는 사진을 삭제합니다.
  ResultFuture<void> deletePhoto(String photoId);
}
