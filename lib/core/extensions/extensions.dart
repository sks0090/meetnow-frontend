// [String]과 [DateTime]에 유용한 확장 메서드를 정의합니다.
//
// Dart의 extension 기능을 이용해 기존 클래스를 수정하지 않고 메서드를 추가합니다.

/// [String]에 대한 확장 메서드를 제공합니다.
extension StringExtension on String {
  /// 첫 글자를 대문자로 변환합니다.
  /// 예) 'hello' → 'Hello'
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// RFC 5322 형식의 이메일이면 true를 반환합니다.
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// 10~15자리 숫자(국제 전화번호 포함)면 true를 반환합니다.
  bool get isValidPhone {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(this);
  }
}

/// [DateTime]에 대한 확장 메서드를 제공합니다.
extension DateTimeExtension on DateTime {
  /// 현재 시각 기준 상대적 시간을 한국어 문자열로 반환합니다.
  ///
  /// 예) 방금 전, 5분 전, 2시간 전, 3일 전, 1개월 전, 2년 전
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays > 365) return '${diff.inDays ~/ 365}년 전';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}개월 전';
    if (diff.inDays > 0) return '${diff.inDays}일 전';
    if (diff.inHours > 0) return '${diff.inHours}시간 전';
    if (diff.inMinutes > 0) return '${diff.inMinutes}분 전';
    return '방금 전';
  }

  /// 현재 날짜 기준으로 만 나이를 계산합니다.
  /// 생일이 아직 지나지 않은 경우 1을 빼서 만 나이를 정확히 반환합니다.
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--; // 아직 생일이 지나지 않았으면 1 감소
    }
    return age;
  }
}
