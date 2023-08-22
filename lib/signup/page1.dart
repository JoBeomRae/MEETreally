import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet/firstloginpage/first.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _saveCredentials = false; // 체크박스의 상태를 저장하기 위한 변수

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 로그인에 성공하면 FirstPage로 이동
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FirstPage()),
      );
    } catch (e) {
      // 로그인 실패하면 에러 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: _saveCredentials,
                  onChanged: (value) {
                    setState(() {
                      _saveCredentials = value!;
                    });
                  },
                ),
                const Text("Save ID/Password")
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
