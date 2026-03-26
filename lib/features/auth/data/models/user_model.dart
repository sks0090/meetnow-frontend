import 'package:meetnow_frontend/features/auth/domain/entities/user.dart';

/// [User] 엔티티의 데이터 모델 — JSON 직렬화/역직렬화를 담당합니다.
///
/// [User]를 확장(상속)하며, 도메인 엔티티와 동일한 필드를 가집니다.
/// 데이터 레이어에서만 사용되며, 도메인 레이어에는 노출되지 않습니다.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.avatarUrl,
    super.age,
    super.bio,
    super.createdAt,
  });

  /// 서버 JSON 응답으로 [UserModel]을 생성합니다.
  /// snake_case 키(`avatar_url`, `created_at`)를 camelCase 필드로 매핑합니다.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// 서버에 전송할 JSON 직렬화 결과를 반환합니다.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'age': age,
      'bio': bio,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
