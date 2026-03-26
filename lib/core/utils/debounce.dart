import 'dart:async';

/// 연속된 함수 호출을 지연시키는 디바운스 유틸리티.
///
/// 마지막 호출 후 [delay]가 지나야 실제 액션을 실행합니다.
/// 검색 입력, 스와이프 갈음장 더비 등에 유용합니다.
///
/// 예:
/// ```dart
/// final debounce = Debounce();
/// void _onSearchChanged(String query) {
///   debounce(() => _search(query));
/// }
/// ```
class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({this.delay = const Duration(milliseconds: 300)});

  /// [action]을 [delay] 후에 실행합니다.
  /// [delay] 전에 다시 호출하면 이전 예약은 취소됩니다.
  void call(void Function() action) {
    _timer?.cancel(); // 이전 타이머가 있으면 취소
    _timer = Timer(delay, action);
  }

  /// 현재 예약된 액션을 취소하고 타이머를 해제합니다.
  /// 위젯이 dispose될 때 호출하세요.
  void dispose() {
    _timer?.cancel();
  }
}
