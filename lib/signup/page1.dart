import 'package:flutter/material.dart';
import 'package:meet/injeung/phonenumber.dart'; // Import the PhoneNumberPage. Replace 'your_project_name' with the name of your project.

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const PhoneNumberPage()), // Go to PhoneNumberPage on button press.
              );
            },
            child: const Text('간편하게 계속하기'),
          ),
        ),
      ),
    );
  }
}
