import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 초기화 상태를 관리하는 Provider.
///
/// 스플래시 화면에서 애니메이션과 병렬로 실행되며,
/// 모든 초기화가 완료되어야 다음 화면으로 이동할 수 있습니다.
///
/// 추가 가능한 초기화 작업:
/// - 토큰 유효성 검증 / 자동 로그인
/// - 앱 설정 로드 (SharedPreferences)
/// - FCM 토큰 등록
/// - 원격 설정(Remote Config) 페치
/// - 캐시 데이터 프리로드
final splashInitProvider = FutureProvider.autoDispose<void>((ref) async {
  // TODO: 필요한 초기화 작업을 여기에 추가
  // 예:
  // await ref.read(authRepositoryProvider).refreshToken();
  // await ref.read(remoteConfigProvider.future);
});
