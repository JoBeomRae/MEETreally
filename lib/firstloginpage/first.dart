import 'package:flutter/material.dart';
import 'package:meet/now/innow.dart';
import 'package:meet/call/incall.dart';
import 'package:meet/chat/inchat.dart';
import 'package:meet/my/inmy.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  static final GlobalKey<FirstPageState> firstPageKey =
      GlobalKey<FirstPageState>();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const InNow(),
      const InCall(),
      const InChat(),
      const InMy(),
    ];

    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: '실시간',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: '전화내역',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Scaffold 배경을 흰색으로 변경

        selectedItemColor: Colors.black, // 선택된 아이템 색상을 검은색으로 변경
        unselectedItemColor:
            const Color.fromARGB(255, 181, 181, 181), // 선택되지 않은 아이템 색상을 회색으로 변경
        elevation: 10, // 그림자 강도를 증가
        showSelectedLabels: true, // 선택된 아이템 레이블 표시
        showUnselectedLabels: true, // 선택되지 않은 아이템 레이블 표시
      ),
    );
  }
}
