import 'package:flutter/material.dart';
import 'package:meetnow_frontend/app/theme/app_colors.dart';

/// 채팅 메시지 입력 위젯.
///
/// 텍스트 입력 필드와 전송 버튼으로 구성됩니다.
/// 텍스트가 비어 있으면 전송 버튼이 비활성화됩니다.
/// [onSend] 콜백으로 부모 위젯(주로 ChatPage)에 메시지를 전달합니다.
class ChatInput extends StatefulWidget {
  final void Function(String content) onSend;

  const ChatInput({super.key, required this.onSend});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) =>
                  setState(() => _hasText = value.trim().isNotEmpty),
              decoration: const InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          IconButton(
            onPressed: _hasText ? _handleSend : null,
            icon: Icon(
              Icons.send_rounded,
              color: _hasText ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
