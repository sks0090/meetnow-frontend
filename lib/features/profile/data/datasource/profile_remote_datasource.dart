import 'package:dio/dio.dart';
import 'package:meetnow_frontend/core/constants/api_paths.dart';
import 'package:meetnow_frontend/features/profile/data/models/profile_model.dart';

/// 프로필 API 데이터소스 계약.
///
/// 내 프로필 조회/수정, 사진 업로드/삭제 기능을 정의합니다.
abstract class ProfileRemoteDataSource {
  /// 내 프로필을 서버에서 가져옵니다.
  Future<ProfileModel> getMyProfile();

  /// 프로필 정보를 부분 수정합니다. [data]에는 변경할 필드만 포함됩니다.
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);

  /// 사진 파일을 업로드하고 서버가 반환한 URL을 반환합니다.
  Future<String> uploadPhoto(String filePath);

  /// [photoId]에 해당하는 사진을 삭제합니다.
  Future<void> deletePhoto(String photoId);
}

/// [ProfileRemoteDataSource] Dio 기반 구현체.
///
/// uploadPhoto는 [FormData]를 사용하며 multipart/form-data로 전송됩니다.
/// updateProfile은 변경된 필드만 담는 Map을 PATCH로 전송합니다.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  const ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileModel> getMyProfile() async {
    final response = await _dio.get(ApiPaths.profile);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.patch(ApiPaths.updateProfile, data: data);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(filePath),
    });
    final response = await _dio.post(ApiPaths.uploadPhoto, data: formData);
    return response.data['photo_url'] as String;
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    await _dio.delete(ApiPaths.deletePhoto(photoId));
  }
}
