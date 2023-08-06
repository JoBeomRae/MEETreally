import 'package:flutter/material.dart';
import 'package:meet/addpage/add.dart'; // 여기에 경로를 정확하게 맞춰주세요.

class FirstPage extends StatefulWidget {
  final String? city;
  final String? district;
  final String? people;

  const FirstPage({this.city, this.district, this.people, Key? key})
      : super(key: key);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('시: ${widget.city ?? ''}'),
            Text('구: ${widget.district ?? ''}'),
            Text('인원: ${widget.people ?? ''}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPage()),
                );
              },
              child: const Text('등록하기'),
            ),
          ],
        ),
      ),
      Container(),
      Container(),
      Container(),
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
