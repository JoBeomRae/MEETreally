import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet/firstloginpage/first.dart';
import 'package:logger/logger.dart';

class EmailNamePage extends StatefulWidget {
  const EmailNamePage({Key? key}) : super(key: key);

  @override
  _EmailNamePageState createState() => _EmailNamePageState();
}

class _EmailNamePageState extends State<EmailNamePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // 이름 입력을 위한 컨트롤러
  final TextEditingController _ageController =
      TextEditingController(); // 나이 입력을 위한 컨트롤러
  final TextEditingController _jobController =
      TextEditingController(); // 직업 입력을 위한 컨트롤러
  final Logger _logger = Logger();

  void _registerUser() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstPage()),
      );
    } catch (error) {
      _logger.e('회원가입 실패: $error');
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
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: '나이'),
              keyboardType: TextInputType.number, // 숫자 입력 키보드를 사용
            ),
            TextField(
              controller: _jobController,
              decoration: const InputDecoration(labelText: '직업'),
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
