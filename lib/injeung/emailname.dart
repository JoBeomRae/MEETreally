import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/firstloginpage/first.dart';

class EmailNamePage extends StatefulWidget {
  const EmailNamePage({super.key});

  @override
  _EmailNamePageState createState() => _EmailNamePageState();
}

class _EmailNamePageState extends State<EmailNamePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
            // 이메일 입력
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: '이메일을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                hintText: '비밀번호를 입력하세요',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // 이름 입력
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            // 나이 입력
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: '나이',
                hintText: '나이를 입력하세요',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 직업 입력
            TextField(
              controller: _jobController,
              decoration: const InputDecoration(
                labelText: '직업',
                hintText: '직업을 입력하세요',
              ),
            ),
            const SizedBox(height: 16),
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () => _registerAccount(context),
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerAccount(BuildContext context) async {
    try {
      // Firebase에 이메일과 비밀번호로 회원가입
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // Firestore에 이름, 나이, 직업 정보 저장
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': _emailController.text,
          'name': _nameController.text,
          'age': _ageController.text,
          'job': _jobController.text,
        });

        // first.dart로 이동
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FirstPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("에러 발생: $e")),
      );
    }
  }
}
