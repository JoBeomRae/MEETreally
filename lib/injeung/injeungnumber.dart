import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet/injeung/emailname.dart'; // 가정: emailname.dart가 injeung 폴더 안에 있습니다.

class InjeungNumberPage extends StatefulWidget {
  final String verificationId;

  const InjeungNumberPage({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _InjeungNumberPageState createState() => _InjeungNumberPageState();
}

class _InjeungNumberPageState extends State<InjeungNumberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _smsController = TextEditingController();
  bool _canContinue = false; // 계속하기 버튼 활성화 상태를 관리하는 변수 추가

  Future<void> _verifySmsCode() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _smsController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const EmailNamePage(), // 가정: EmailNamePage가 emailname.dart에 정의되어 있습니다.
        ),
      );
    } catch (e) {
      // 인증 코드가 틀릴 경우 오류 처리
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('잘못된 인증 코드입니다.')));
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
            const Text('인증번호를 입력해 주세요.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              '인증 번호가 전송됐어요. 받은 번호를 입력하면 인증이 완료돼요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _smsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(), // 밑줄로만 표시
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              maxLength: 6,
              onChanged: (value) {
                setState(() {
                  _canContinue = value.length == 6; // 6자리일 때만 계속하기 가능
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue ? _verifySmsCode : null, // 6자리 입력 시 활성화
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
