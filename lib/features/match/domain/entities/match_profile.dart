/// 탐색(Discover) 화면에서 카드로 표시되는 상대방 프로필 엔티티.
///
/// [distance]는 현재 사용자와의 거리(km)로, 위치 서비스를 허락한 경우에만 값이 있습니다.
class MatchProfile {
  final String id;
  final String name;
  final int age;
  final String? bio;
  final List<String> photoUrls;
  final double? distance; // km 단위. null이면 거리 정보 없음

  const MatchProfile({
    required this.id,
    required this.name,
    required this.age,
    this.bio,
    this.photoUrls = const [],
    this.distance,
  });
}
