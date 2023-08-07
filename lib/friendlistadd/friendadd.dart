import 'package:flutter/material.dart';

class FriendAddPage extends StatefulWidget {
  const FriendAddPage({super.key});

  @override
  _FriendAddPageState createState() => _FriendAddPageState();
}

class _FriendAddPageState extends State<FriendAddPage> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '친구 닉네임',
                hintText: '친구 닉네임을 입력하세요.',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 찾아보기 버튼을 눌렀을 때 수행할 액션을 여기에 추가하세요.
                // 예: _nicknameController.text를 사용하여 닉네임을 검색하거나, 해당 닉네임의 프로필을 불러옵니다.
              },
              child: const Text('찾아보기'),
            ),
          ],
        ),
      ),
    );
  }
}
