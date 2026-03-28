import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 색상 팔레트를 정의합니다.
///
/// 인스턴스 생성이 불필요하므로 [abstract class]로 선언합니다.
/// 모든 색상은 `const`로 컴파일 타임에 결정됩니다.
abstract class AppColors {
  // ── 브랜드 주색상 (크림슨 로즈 계열) ────────────────────────────────────────
  // Color.fromARGB(255, 187, 38, 73) = 0xFFBB2649
  static const Color primary = Color(0xFFBB2649);
  static const Color primaryLight = Color(0xFFDB6B8B); // 연한 로즈 (배경, 뱃지 등)
  static const Color primaryDark = Color(0xFF8C1A36); // 진한 크림슨 (눌림 효과 등)

  // ── 보조색상 (애머시스트 퍼플 계열) ─────────────────────────────────────────
  // primary H=347°에 대한 아날로그 보색 계열 (H=287° ~ 317°)
  static const Color secondary = Color(0xFF7B4FA0);
  static const Color secondaryLight = Color(0xFFA67EC8);
  static const Color secondaryDark = Color(0xFF573375);

  // ── 중립 색상 (레이아웃 / 텍스트) ──────────────────────────────────────────
  static const Color background = Color(0xFFFDF6F8); // 따뜻한 로즈 화이트 배경
  static const Color surface = Color(0xFFFFFFFF); // 카드, 시트 배경
  static const Color textPrimary = Color(0xFF1A1425); // 약간 따뜻한 다크
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF); // 플레이스홀더 텍스트
  static const Color border = Color(0xFFEAE0E4); // 로즈 틴트 보더
  static const Color divider = Color(0xFFF5EEF1); // 로즈 틴트 디바이더

  // ── 상태 색상 ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981); // 성공, 완료
  static const Color warning = Color(0xFFF59E0B); // 경고
  static const Color error = Color(0xFFEF4444); // 오류, 삭제
  static const Color info = Color(0xFF3B82F6); // 정보

  // ── 매칭 액션 색상 ──────────────────────────────────────────────────────────
  static const Color like = Color(0xFF10B981); // 좋아요 버튼 (녹색)
  static const Color nope = Color(0xFFEF4444); // 싫어요 버튼 (빨간색)
  static const Color superLike = Color(0xFF3B82F6); // 슈퍼 좋아요 (파란색)

  // ── 온라인 상태 표시 ────────────────────────────────────────────────────────
  static const Color online = Color(0xFF10B981); // 접속 중
  static const Color offline = Color(0xFF9CA3AF); // 오프라인
}
