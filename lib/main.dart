import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:meet/now/innow.dart';
import 'package:meet/signup/page1.dart';
import 'package:meet/injeung/phonenumber.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase 초기화 전에 반드시 호출
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider<UserData>(
      create: (context) => UserData(),
      child: const MeetApp(),
    ),
  );
}

class MeetApp extends StatelessWidget {
  const MeetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showButtons = false; // 버튼을 표시하는 flag

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -4).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showButtons = true; // 애니메이션이 끝나면 버튼을 표시합니다.
          });
        }
      });

    // 3초 대기 후 애니메이션 시작
    Future.delayed(const Duration(seconds: 3), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ignore: prefer_final_fields
  Color _phoneAuthButtonColor = Colors.blue; // 기본값 설정, 원하는 색으로 변경 가능

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, _animation.value),
            child: Image.asset('assets/MEET.png'),
          ),
          if (_showButtons)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // 버튼을 아래로 이동
                  children: [
                    const Text(
                      '헌팅 플랫폼',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight:
                              FontWeight.bold), // 여기에 폰트 크기와 스타일을 원하시는 대로 조절 가능
                    ),
                    const SizedBox(height: 75),
                    const Text(
                      '우리 MEET으로 헌팅해요',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: double.infinity,
                      height: 50, // 버튼의 세로 크기 설정
                      child: ElevatedButton(
                        onPressed: () {
                          // 카카오톡 로그인 코드 추가
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Page1()),
                          );
                        },
                        // ignore: sort_child_properties_last
                        child: const Text('카카오톡으로 시작하기'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.yellow),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black), // 글자색
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // 휴대폰 인증 코드 추가
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PhoneNumberPage()),
                          );
                        },
                        // ignore: sort_child_properties_last
                        child: const Text('휴대폰 인증으로 시작하기'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              _phoneAuthButtonColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100), // 버튼과 화면 하단 간의 여백 추가
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
