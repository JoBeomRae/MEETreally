import 'package:flutter/material.dart';
import 'package:meet/firstloginpage/first_page.dart'; // Import the FirstPage. Replace 'your_project_name' with the name of your project.

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: const Center(
        child: Text('회원가입 화면'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FirstPage()),
            );
          },
          child: const Text('다음'),
        ),
      ),
    );
  }
}
