import 'package:meetnow_frontend/features/profile/domain/entities/profile.dart';

/// [Profile] 엔티티의 데이터 모델 (JSON 역직렬화/직렬화 담당).
///
/// 서버 응답의 snake_case 필드를 camelCase 필드로 맵핑합니다.
class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.age,
    super.bio,
    super.gender,
    super.photoUrls,
    super.interests,
    super.latitude,
    super.longitude,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      photoUrls:
          (json['photo_urls'] as List?)?.map((e) => e as String).toList() ?? [],
      interests:
          (json['interests'] as List?)?.map((e) => e as String).toList() ?? [],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'bio': bio,
      'gender': gender,
      'photo_urls': photoUrls,
      'interests': interests,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
