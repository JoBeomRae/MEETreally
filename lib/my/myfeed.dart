import 'package:flutter/material.dart';

class MyFeedPage extends StatefulWidget {
  const MyFeedPage({Key? key}) : super(key: key);

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 피드'),
      ),
      body: const Center(
        child: Text('내 피드 내용이 여기에 표시됩니다.'),
      ),
    );
  }
}
