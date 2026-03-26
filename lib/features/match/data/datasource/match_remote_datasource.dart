import 'package:dio/dio.dart';
import 'package:meetnow_frontend/core/constants/api_paths.dart';
import 'package:meetnow_frontend/features/match/data/models/match_profile_model.dart';

/// 매칭 API 데이터소스 계약.
abstract class MatchRemoteDataSource {
  Future<List<MatchProfileModel>> getDiscoverProfiles();
  Future<bool> likeProfile(String profileId);
  Future<void> dislikeProfile(String profileId);
}

/// [MatchRemoteDataSource] Dio 기반 구현체.
///
/// likeProfile은 서버 응답의 is_match 필드를 반환 (매칭 여부).
class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final Dio _dio;

  const MatchRemoteDataSourceImpl(this._dio);

  @override
  Future<List<MatchProfileModel>> getDiscoverProfiles() async {
    final response = await _dio.get(ApiPaths.discover);
    final data = response.data as List;
    return data
        .map((e) => MatchProfileModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> likeProfile(String profileId) async {
    final response = await _dio.post(
      ApiPaths.like,
      data: {'profile_id': profileId},
    );
    return response.data['is_match'] as bool? ?? false;
  }

  @override
  Future<void> dislikeProfile(String profileId) async {
    await _dio.post(
      ApiPaths.dislike,
      data: {'profile_id': profileId},
    );
  }
}
