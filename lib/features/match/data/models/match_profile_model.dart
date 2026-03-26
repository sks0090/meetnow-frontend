import 'package:meetnow_frontend/features/match/domain/entities/match_profile.dart';

/// [MatchProfile] 엔티티의 데이터 모델 (JSON 역직렬화 담당).
///
/// [distance]는 서버에서 null로 돌아올 수 있으므로 ?.toDouble()로 안전하게 파싱합니다.
class MatchProfileModel extends MatchProfile {
  const MatchProfileModel({
    required super.id,
    required super.name,
    required super.age,
    super.bio,
    super.photoUrls,
    super.distance,
  });

  factory MatchProfileModel.fromJson(Map<String, dynamic> json) {
    return MatchProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      bio: json['bio'] as String?,
      photoUrls:
          (json['photo_urls'] as List?)?.map((e) => e as String).toList() ?? [],
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }
}
