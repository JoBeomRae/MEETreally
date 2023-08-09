import 'package:flutter/material.dart';
import 'package:meet/injeung/injeungnumber.dart'; // Import the InjeungNumberPage
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:logger/logger.dart'; // Import logger

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key? key}) : super(key: key);

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _controller = TextEditingController(text: '+82');
  bool _canContinue = false;
  final _auth = FirebaseAuth.instance;
  final _logger = Logger();
  String? _verificationId; // verificationId를 저장하기 위한 변수 추가

  Future<void> _verifyPhoneNumber() async {
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      _logger.i(
          "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}");
    }

    verificationFailed(FirebaseAuthException e) {
      _logger.i(
          "Phone number verification failed. Code: ${e.code}. Message: ${e.message}");
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      _logger.i('Please check your phone for the verification code.');
      _verificationId = verificationId; // 받은 verificationId 저장
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _logger.i("verification code: $verificationId");
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _controller.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      _logger.i("Failed to Verify Phone Number: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
            const SizedBox(height: 8),
            const Text(
              '허위/중복 가입을 막고, 악성 사용자를 제제하는데 사용합니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '010-xxxx-xxxx',
              ),
              onTap: () {
                // 사용자가 입력 칸을 탭하면 커서를 '+82' 뒤로 이동
                _controller.selection =
                    TextSelection.collapsed(offset: _controller.text.length);
              },
              onChanged: (value) {
                setState(() {
                  _canContinue = value.isNotEmpty && value != "+82";
                });
                if (value.isNotEmpty && value != "+82") {
                  _verifyPhoneNumber();
                }
              },
            ),
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: _canContinue
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InjeungNumberPage(
                                verificationId: _verificationId ?? '')),
                      );
                    }
                  : null,
              child: const Text('계속하기'),
            ),
          ],
        ),
      ),
    );
  }
}
