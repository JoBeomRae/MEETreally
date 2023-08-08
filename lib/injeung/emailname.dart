import 'package:flutter/material.dart';

class EmailNamePage extends StatefulWidget {
  const EmailNamePage({super.key});

  @override
  _EmailNamePageState createState() => _EmailNamePageState();
}

class _EmailNamePageState extends State<EmailNamePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원 정보 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: '이메일을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: '비밀번호를 입력하세요',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: '나이',
                hintText: '나이를 입력하세요',
              ),
              keyboardType: TextInputType.number, // 숫자만 입력 가능하도록 설정
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jobController,
              decoration: const InputDecoration(
                labelText: '직업',
                hintText: '직업을 입력하세요',
              ),
            ),
          ],
        ),
      ),
    );
  }
}