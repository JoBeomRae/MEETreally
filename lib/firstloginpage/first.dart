import 'package:flutter/material.dart';
import 'package:meet/addpage/add.dart'; // 여기에 경로를 정확하게 맞춰주세요.
import 'package:meet/friendlist/friend.dart'; // 친구 목록 페이지의 경로로 수정

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
            InkWell(
              onTap: () {
                // 시, 구, 인원을 클릭했을 때 수행할 작업을 여기에 추가합니다.
                // 예를 들어, 해당 정보에 대한 상세 페이지로 이동할 수 있습니다.
              },
              child: Column(
                children: [
                  if (widget.city != null && widget.district != null)
                    Text(
                        '지역: ${widget.city} ${widget.district}'), // 여기에서 '시'와 '구' 값을 함께 출력합니다.
                  if (widget.people != null) Text('인원: ${widget.people}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 전화하기 버튼을 눌렀을 때 수행할 작업을 여기에 추가합니다.
                  },
                  child: const Text('전화하기'),
                ),
                const SizedBox(width: 10), // 두 버튼 사이의 간격을 조절합니다.
                ElevatedButton(
                  onPressed: () {
                    // 채팅하기 버튼을 눌렀을 때 수행할 작업을 여기에 추가합니다.
                  },
                  child: const Text('채팅하기'),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(),
      Container(),
      Container(),
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
        backgroundColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
      // "실시간" 탭에서만 + 버튼을 보여주기 위한 조건을 추가
      floatingActionButton: buildFloatingButton(),
    );
  }

  Widget? buildFloatingButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      );
    } else if (_selectedIndex == 3) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FriendListPage()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.group_add),
      );
    }
    return null; // 아무 버튼도 반환하지 않는 경우
  }
}
