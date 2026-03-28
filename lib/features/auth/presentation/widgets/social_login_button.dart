import 'package:flutter/material.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';

/// 소셜 로그인 버튼 (카카오, 구글, 애플 등)에 재사용 가능한 위젯.
///
/// [backgroundColor]와 [foregroundColor]로 버튼 색상을 커스터마이즈할 수 있습니다.
/// 기본값은 흰 배경 + 어두운 텍스트입니다.
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  /// 버튼 배경색. null이면 흰색(기본).
  final Color? backgroundColor;

  /// 아이콘/텍스트 색상. null이면 [AppColors.textPrimary](기본).
  final Color? foregroundColor;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.surface;
    final fg = foregroundColor ?? AppColors.textPrimary;
    // 배경이 흰색(기본)이면 테두리 표시, 그 외 배경색이 있으면 테두리 제거
    final hasBorder = backgroundColor == null;

    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: hasBorder ? 0 : 2,
        side: hasBorder
            ? const BorderSide(color: AppColors.border)
            : BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
