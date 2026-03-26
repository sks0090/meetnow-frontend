import 'package:logger/logger.dart';

/// 앱 전체에서 사용하는 전역 로거 인스턴스.
///
/// [PrettyPrinter]를 사용해 콘솔에 가독성 높은 출력을 제공합니다.
///
/// 사용 예:
/// ```dart
/// appLogger.d('디버그 메시지');
/// appLogger.i('정보 메시지');
/// appLogger.w('경고 메시지');
/// appLogger.e('에러', error: e, stackTrace: s);
/// ```
final appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // 스택 트레이스에 표시할 호출 동코 수
    errorMethodCount: 5, // 에러 시 표시할 호출 동코 수
    lineLength: 80,
    colors: true,
    printEmojis: true,
  ),
);
