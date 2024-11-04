import 'package:flutter/material.dart';

class AuditView extends StatefulWidget {
  const AuditView({super.key});

  @override
  AuditViewState createState() => AuditViewState();
}

class AuditViewState extends State<AuditView> {
  String? _pastedText;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200, // Set a fixed height for the TextField container
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.grey), // Add border to the container
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: TextField(
                key: const Key('Audit TextField'),
                controller: _textController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Paste your text here',
                  border: InputBorder.none, // Remove border from the TextField
                ),
                onChanged: (text) {
                  setState(() {
                    _pastedText = text;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            key: const Key('Submit Button'),
            onPressed: () {
              setState(() {
                _pastedText = _textController.text;
              });
            },
            child: const Text('Submit Text'),
          ),
          const SizedBox(height: 20),
          Text(
            _pastedText != null
                ? (_pastedText!.length > 100
                    ? '${_pastedText!.substring(0, 100)}...'
                    : _pastedText!)
                : 'No text pasted',
            key: const Key('Truncated Text'),
          ),
        ],
      ),
    );
  }
}
