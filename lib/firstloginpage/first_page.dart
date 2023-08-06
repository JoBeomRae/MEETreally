import 'package:flutter/material.dart';
import 'package:meet/addpage/add.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 각 탭에 대응하는 위젯 리스트
    final List<Widget> widgetOptions = <Widget>[
      Center(
        child: ElevatedButton(
          // '등록하기' 버튼
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPage()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white), // 버튼의 배경색을 흰색으로 설정
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.black), // 버튼의 텍스트 색상을 검은색으로 설정
          ),
          child: const Text('등록하기'),
        ),
      ),
      Container(), // 빈 위젯
      Container(), // 빈 위젯
      Container(), // 빈 위젯
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('첫 페이지'),
      ),
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
        backgroundColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
