
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
      backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,  // 중앙에 위치하기 위해 변경
        children: [
          const SizedBox(height: 50),  // <-- 이 부분을 추가함

          const Text(
            "MEET",
            textAlign: TextAlign.center,  // 중앙 정렬
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),  // 간격 조절을 위한 SizedBox

          const Text(
            "우리 MEET으로 헌팅해요",
            textAlign: TextAlign.center,  // 중앙 정렬
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),


          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '이메일',
                  labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트를 검은색으로 설정

              hintText: '이메일을 입력하세요',
              filled: true,
             fillColor: Colors.white, // 배경색을 흰색으로 설정

              border: OutlineInputBorder(),
focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.0), // 포커스된 테두리 색상을 빨간색으로
    ),
  ),
),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: '비밀번호',
                  labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트를 검은색으로 설정

              hintText: '비밀번호를 입력하세요',
              filled: true,
                  fillColor: Colors.white, // 배경색을 흰색으로 설정

              border: OutlineInputBorder(),
focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.0), // 포커스된 테두리 색상을 빨간색으로
    ),
  ),
),
          const SizedBox(height: 16),
        
SizedBox(
  height: 46,
   width: double.infinity,  // 가로로 화면에 가득 차게 설정
  child: ElevatedButton(
    onPressed: _signIn,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: const Text('로그인',
          style: TextStyle(fontSize: 21)),  // fontSize 값을 변경하여 텍스트 크기 조절

  ),
),

  const SizedBox(height: 16),
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
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
        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
      ),
    ),
    const SizedBox(height: 8),  // 아이디/비밀번호 찾기와 회원가입 사이의 간격 조정
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
        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
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