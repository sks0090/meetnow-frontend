import 'package:fpdart/fpdart.dart';
import 'package:meetnow_frontend/core/error/exceptions.dart';
import 'package:meetnow_frontend/core/error/failures.dart';
import 'package:meetnow_frontend/features/match/data/datasource/match_remote_datasource.dart';
import 'package:meetnow_frontend/features/match/domain/entities/match_profile.dart';
import 'package:meetnow_frontend/features/match/domain/repositories/match_repository.dart';

/// [MatchRepository] 구현체.
///
/// 데이터소스의 예외를 [ServerFailure]로 변환하여 Either 모나드로 반환합니다.
class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource _remoteDataSource;

  const MatchRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<List<MatchProfile>> getDiscoverProfiles() async {
    try {
      final profiles = await _remoteDataSource.getDiscoverProfiles();
      return Right(profiles);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<bool> likeProfile(String profileId) async {
    try {
      final isMatch = await _remoteDataSource.likeProfile(profileId);
      return Right(isMatch);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> dislikeProfile(String profileId) async {
    try {
      await _remoteDataSource.dislikeProfile(profileId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
