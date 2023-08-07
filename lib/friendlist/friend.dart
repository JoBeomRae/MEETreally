import 'package:flutter/material.dart';
import 'package:meet/friendlistadd/friendadd.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({Key? key}) : super(key: key);

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  Widget _buildFriendInfo(
      IconData icon, String nickname, String name, int age, String job) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(icon),
      ),
      title: Text('닉네임: $nickname'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이름: $name'),
          Text('나이: $age'),
          Text('직업: $job'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // 아이콘의 색을 검정색으로 설정
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '친구 목록',
          style: TextStyle(color: Colors.black), // 텍스트의 색을 검정색으로 설정
        ),
      ),
      body: ListView(
        children: [
          _buildFriendInfo(Icons.person, '메기남', '김현규', 29, '소방관'),
          _buildFriendInfo(Icons.person, '차바론', '차민창', 29, '화성남'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FriendAddPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
