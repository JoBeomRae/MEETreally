import 'package:flutter/material.dart';
import 'package:meet/injeung/injeungnumber.dart'; // Import the InjeungNumberPage

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // This line adds the back button
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
            color:
                Colors.black), // This line changes the color of the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '휴대폰 번호를 입력해주세요.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
                height:
                    8), // Add some space between the text and the input field
            const Text(
              '허위/중복 가입을 막고, 악성 사용자를 제제하는데 사용합니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
                height:
                    16), // Add some space between the text and the input field
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '010-xxxx-xxxx',
              ),
            ),
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InjeungNumberPage()),
                );
              },
              child: const Text('계속하기'),
            ),
          ],
        ),
      ),
    );
  }
}
