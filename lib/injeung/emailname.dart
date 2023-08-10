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
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 제거
      // appBar: AppBar(title: const Text('회원 정보 입력')),
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
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                hintText: '닉네임을 입력하세요',
              ),
            ),
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
            // "계속하기" 버튼 스타일로 변경
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _registerAccount(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEE71),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  '계속하기',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerAccount(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': _emailController.text,
          'nickname': _nicknameController.text,
          'name': _nameController.text,
          'age': _ageController.text,
          'job': _jobController.text,
        });

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
