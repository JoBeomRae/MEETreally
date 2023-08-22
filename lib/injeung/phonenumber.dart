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
      backgroundColor: Colors.white,
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
            const Text('휴대폰 번호를 입력해주세요.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              '허위/중복 가입을 막고, 악성 사용자를 제제하는데 사용합니다.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '+82휴대폰번호를 입력해주세요.',
                      border: UnderlineInputBorder(), // 밑줄로만 표시
                    ),
                    onChanged: (value) {
                      setState(() {
                        _canContinue = value.length == 15; // 14자리일 때만 계속하기 가능
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue
                    ? () async {
                        await _verifyPhoneNumber();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InjeungNumberPage(
                              verificationId: _verificationId ?? '',
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 0, 0, 0), // 버튼의 배경색 설정
                  foregroundColor:
                      const Color.fromARGB(255, 255, 255, 255), // 버튼의 텍스트 색상
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 버튼 패딩
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)), // 버튼 모서리 둥글게
                ),
                child: const Text(
                  '계속하기',
                  style: TextStyle(fontSize: 21), // 텍스트 크기를 21로 설정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
