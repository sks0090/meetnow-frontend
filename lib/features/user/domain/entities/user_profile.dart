/// 다른 사용자의 공개 프로필 엔티티.
///
/// [UserProfile]은 내 [Profile]과 달리 타인을 조회할 때 사용됩니다.
/// [isOnline]과 [lastSeen]은 사용자의 접속 상태를 나타냅니다.
class UserProfile {
  final String id;
  final String name;
  final int? age;
  final String? bio;
  final List<String> photoUrls;
  final bool isOnline; // 현재 접속 중인지 여부
  final DateTime? lastSeen; // isOnline이 false일 때 마지막 접속 시각

  const UserProfile({
    required this.id,
    required this.name,
    this.age,
    this.bio,
    this.photoUrls = const [],
    this.isOnline = false,
    this.lastSeen,
  });
}
