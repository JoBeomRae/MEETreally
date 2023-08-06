import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('첫 페이지'),
      ),
      body: const Center(
        child: Text('로그인 후 첫 페이지 화면'),
      ),
    );
  }
}
