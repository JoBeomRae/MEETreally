import 'package:flutter/material.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  _FindPasswordPageState createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final TextEditingController _emailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("비밀번호 찾기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: '이메일 주소를 입력하세요',
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
           
          ],
        ),
      ),
    );
  }
}
