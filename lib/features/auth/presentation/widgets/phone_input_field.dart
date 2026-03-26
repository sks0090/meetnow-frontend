import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 전화번호 입력 필드 위젯.
///
/// 숫자만 입력 가능하며 최대 11자리로 제한됩니다.
/// 국가 코드(+82)가 prefix로 표시됩니다.
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      decoration: const InputDecoration(
        hintText: '전화번호',
        prefixIcon: Icon(Icons.phone_outlined),
        prefixText: '+82 ',
      ),
      validator: validator,
    );
  }
}
