/// 내 프로필 도메인 엔티티.
///
/// [User] 엔티티보다 더 많은 정보(사진, 관심사, 위치 등)를 담습니다.
/// [latitude], [longitude]는 위치 기반 매칭에 사용됩니다.
class Profile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final int? age;
  final String? bio;
  final String? gender;
  final List<String> photoUrls; // 프로필 사진 URL 목록 (순서 = 표시 순서)
  final List<String> interests; // 관심사 태그 목록
  final double? latitude; // WGS84 위도 (도 단위)
  final double? longitude; // WGS84 경도 (도 단위)

  const Profile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.age,
    this.bio,
    this.gender,
    this.photoUrls = const [],
    this.interests = const [],
    this.latitude,
    this.longitude,
  });
}
