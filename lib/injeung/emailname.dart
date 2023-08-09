import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet/firstloginpage/first.dart';
import 'package:logger/logger.dart'; // logger 패키지 임포트


class EmailNamePage extends StatefulWidget {
  const EmailNamePage({super.key});

  @override
  _EmailNamePageState createState() => _EmailNamePageState();
}

class _EmailNamePageState extends State<EmailNamePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    final Logger _logger = Logger(); // logger 인스턴스 생성


  void _registerUser() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 회원가입 성공 시, first.dart 페이지로 이동
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstPage()),
      );
    } catch (error) {
      // 회원가입 실패 처리 (예: 에러 메시지 출력)
      _logger.e('회원가입 실패: $error'); // 로깅 프레임워크를 통한 로그 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('회원가입완료'),
            ),
          ],
        ),
      ),
    );
  }
}
