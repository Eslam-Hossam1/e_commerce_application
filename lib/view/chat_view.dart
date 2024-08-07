import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, this.text});
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat view"),
      ),
      body: Text(text ?? 'null'),
    );
  }
}
