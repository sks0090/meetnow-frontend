/// 실행 환경을 구분하는 열거형.
///
/// - [dev]: 로컬 개발 환경 (localhost)
/// - [staging]: 스테이징 서버 (배포 전 QA 환경)
/// - [prod]: 실제 운영 서버
enum Environment { dev, staging, prod }

/// 현재 실행 환경에 따른 설정값을 제공하는 클래스.
///
/// [init]을 통해 앱 시작 시 환경을 한 번 설정하면,
/// 이후 [baseUrl], [wsUrl] 등의 getter로 해당 환경의 값을 가져올 수 있습니다.
class Env {
  static Environment _currentEnv = Environment.dev;

  /// 현재 설정된 환경을 반환합니다.
  static Environment get currentEnv => _currentEnv;

  /// 앱 시작 시 환경을 설정합니다. [main.dart]에서 한 번만 호출해야 합니다.
  static void init(Environment env) {
    _currentEnv = env;
  }

  /// REST API 기본 URL을 반환합니다. 환경에 따라 다른 주소를 제공합니다.
  static String get baseUrl {
    switch (_currentEnv) {
      case Environment.dev:
        return 'http://localhost:8080/api/v1';
      case Environment.staging:
        return 'https://staging-api.meetnow.app/api/v1';
      case Environment.prod:
        return 'https://api.meetnow.app/api/v1';
    }
  }

  /// WebSocket 서버 URL을 반환합니다. 실시간 채팅에 사용됩니다.
  static String get wsUrl {
    switch (_currentEnv) {
      case Environment.dev:
        return 'ws://localhost:8080/ws';
      case Environment.staging:
        return 'wss://staging-api.meetnow.app/ws';
      case Environment.prod:
        return 'wss://api.meetnow.app/ws';
    }
  }

  /// 개발 환경 여부. 개발 전용 기능(로그 출력 등)에 사용합니다.
  static bool get isDev => _currentEnv == Environment.dev;
  static bool get isStaging => _currentEnv == Environment.staging;
  static bool get isProd => _currentEnv == Environment.prod;

  // ── 외부 SDK 키 (--dart-define으로 빌드 시 주입) ─────────────────────────
  // 빌드 명령 예: flutter run --dart-define=KAKAO_NATIVE_APP_KEY=abc123
  //
  // 값이 없으면 빈 문자열 → KakaoSdk.init()에서 런타임 에러로 조기 발견 가능.
  // .env 파일이나 소스코드에 실제 값을 커밋하지 마세요.

  static const kakaoNativeAppKey =
      String.fromEnvironment('0cdcc09df03d33b6f452245b8d40e2c2');
}
