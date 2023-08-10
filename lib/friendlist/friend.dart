// friend.dart
import 'package:flutter/material.dart';

class FriendList extends StatelessWidget {
  const FriendList({super.key});

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
        onPressed: () {
          // + 버튼을 클릭했을 때의 동작을 여기에 작성하십시오.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
