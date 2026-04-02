import 'package:fpdart/fpdart.dart';
import 'package:meetnow_frontend/core/error/exceptions.dart';
import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:meetnow_frontend/features/profile/domain/entities/profile.dart';
import 'package:meetnow_frontend/features/profile/domain/repositories/profile_repository.dart';

/// [ProfileRepository] 구현체.
///
/// 데이터소스의 예외를 [ServerFailure]로 변환하여 Either 모나드로 반환합니다.
/// updateProfile에서는 null이 아닌 필드만 Map에 담아 PATCH 요청으로 업데이트합니다.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<Profile> getMyProfile() async {
    try {
      final profile = await _remoteDataSource.getMyProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<Profile> updateProfile({
    String? name,
    String? bio,
    int? age,
    String? gender,
    List<String>? interests,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (bio != null) data['bio'] = bio;
      if (age != null) data['age'] = age;
      if (gender != null) data['gender'] = gender;
      if (interests != null) data['interests'] = interests;

      final profile = await _remoteDataSource.updateProfile(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<String> uploadPhoto(String filePath) async {
    try {
      final url = await _remoteDataSource.uploadPhoto(filePath);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> deletePhoto(String photoId) async {
    try {
      await _remoteDataSource.deletePhoto(photoId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
