import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:meet/firstloginpage/first.dart';
import 'package:meet/injeung/phonenumber.dart';
import 'package:meet/injeung/findpassword.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Page1());
}

final logger = Logger();

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        logger.i('로그인 성공: ${userCredential.user?.email}');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          // 현재 페이지를 교체
          context,
          MaterialPageRoute(builder: (context) => const FirstPage()),
        );
      } else {
        logger.w('로그인 실패');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,  // 버튼을 확장하기 위해 변경
        children: [
          const Text(
            "MEET으로 헌팅해요",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '이메일',
              hintText: '이메일을 입력하세요',
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: '비밀번호',
              hintText: '비밀번호를 입력하세요',
              filled: true,
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEE71),  // 버튼의 배경색을 #ffee71로 설정
              foregroundColor : Colors.black,  // 버튼의 글자색을 검은색으로 설정
            ),
            child: const Text('로그인'),
          ),
         const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FindPasswordPage()),  // 아이디/비밀번호 찾기 페이지로 이동
                  );
                },
                child: const Text(
                  '아이디/비밀번호 찾기',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PhoneNumberPage()),  // 회원가입 페이지로 이동
                  );
                },
                child: const Text(
                  '회원가입',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}