import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  static const routeName = '/chats-screen';
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats Screen'),
      ),
    );
  }
}
