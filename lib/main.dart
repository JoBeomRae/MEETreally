import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet/signup/page1.dart';
// Import the FirstPage. Replace 'your_project_name' with the name of your project.

void main() {
  runApp(const MeetApp());
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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'MEET',
          style: TextStyle(
              fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
