// friend.dart
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구목록'),
      ),
      body: const Center(
        child: Text('친구 목록을 여기에 표시합니다!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFriendDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  _showAddFriendDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("닉네임을 입력하세요"),
          content: TextField(controller: _nicknameController),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context); // 창을 닫습니다.
              },
            ),
          ],
        );
      },
    );
  }
}
