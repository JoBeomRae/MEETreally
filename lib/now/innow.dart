import 'package:flutter/material.dart';
import 'package:meet/now/nowplus.dart';

class InNow extends StatefulWidget {
  const InNow({super.key});

  @override
  _InNowPageState createState() => _InNowPageState();
}

class _InNowPageState extends State<InNow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
      appBar: AppBar(
        backgroundColor: Colors.white, // 앱바의 색상을 흰색으로 설정
        title: const Text(
          '실시간',
          style: TextStyle(color: Colors.black), // 제목의 색상을 검은색으로 설정
        ),
        elevation: 0, // 앱바의 그림자와 테두리를 없앤다
      ),
      body: const Center(
        child: Text('InNow Page Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NowPlusPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
