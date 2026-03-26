/// 인증 기능의 도메인 엔티티 — 로그인한 사용자를 나타냅니다.
///
/// 도메인 레이어에 속하며 Flutter/Dart 특정 구현에 의존하지 않는 순수 Dart 객체입니다.
/// JSON 직렬화는 [UserModel]에서 담당합니다.
class User {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl; // 프로필 사진 URL
  final int? age;
  final String? bio; // 자신 소개 등
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.age,
    this.bio,
    this.createdAt,
  });
}
