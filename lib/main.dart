import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meet/signup/page1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet/now/in_now_model.dart'; // InNowModel을 import 합니다.
import 'firebase_options.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MeetApp());
}

class MeetApp extends StatelessWidget {
  const MeetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 최상위 위젯에서 ChangeNotifierProvider를 사용하여 InNowModel을 제공합니다.
    return ChangeNotifierProvider(
      create: (context) => InNow(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Page1()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Image.asset('assets/MEET.png'),
      ),
    );
  }
}
