import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageTextBox extends StatefulWidget {
  const MessageTextBox({required this.onSend, super.key});

  final void Function(String) onSend;

  @override
  State<MessageTextBox> createState() => _MessageTextBoxState();
}

class _MessageTextBoxState extends State<MessageTextBox> {
  final TextEditingController _messageController = TextEditingController();
  bool _hasText = false;

  void _updateTextState() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void onSend(String message) {
    if (message.isNotEmpty) {
      widget.onSend(message);
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_updateTextState);
  }

  @override
  void dispose() {
    _messageController.removeListener(_updateTextState);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: .end,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: Focus(
                // Handle Enter key to send message, but allow Shift+Enter for new lines
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter &&
                      !HardwareKeyboard.instance.isShiftPressed) {
                    onSend(_messageController.text.trim());
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ask anything',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  cursorHeight: 18,
                  cursorWidth: 1.25,
                  maxLines: null,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
          ),
          sendButton(),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget sendButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        icon: const Icon(Icons.send),
        onPressed: _hasText
            ? () => onSend(_messageController.text.trim())
            : null,
        tooltip: 'Send',
      ),
    );
  }
}
