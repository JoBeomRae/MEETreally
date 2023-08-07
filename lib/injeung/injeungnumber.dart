import 'package:flutter/material.dart';

class InjeungNumberPage extends StatelessWidget {
  const InjeungNumberPage({Key? key}) : super(key: key);

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
              '인증번호를 입력해 주세요.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
                height:
                    8), // Add some space between the text and the input field
            const Text(
              '인증 번호가 전송됐어요. 받은 번호를 입력하면 인증이 완료돼요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
                height:
                    16), // Add some space between the text and the input field
            Row(
              children: <Widget>[
                const Text(
                  '+82',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                    width:
                        8), // Add some space between the '+82' and the input field
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '받은 번호',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 16), // Add some space between the input fields
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '6자리 숫자',
              ),
              maxLength: 6,
            ),
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
              onPressed: () {
                // Insert the code to move to the next page here
              },
              child: const Text('계속하기'),
            ),
          ],
        ),
      ),
    );
  }
}
