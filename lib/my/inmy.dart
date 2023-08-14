import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/my/friend.dart';
import 'package:meet/my/myfeed.dart'; // <-- 추가한 코드
import 'package:logger/logger.dart';

final logger = Logger();

class InMy extends StatefulWidget {
  const InMy({super.key});

  @override
  _InMyState createState() => _InMyState();
}

class _InMyState extends State<InMy> {
  User? user;
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      fetchUserInfo(user!);
    }
  }

  Future<void> fetchUserInfo(User user) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      userInfo = doc.data() as Map<String, dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (userInfo != null) ...[
            Text("닉네임: ${userInfo!['nickname']}"),
            Text("이름: ${userInfo!['name']}"),
            Text("나이: ${userInfo!['age'].toString()}"),
            Text("직업: ${userInfo!['job']}"),
          ] else ...[
            const Text("정보를 가져오는 중..."),
          ],
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyFeedPage()),
              );
            },
            child: const Text('내 피드 보러가기'),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendList()),
              );
            },
            child: const Text('친구목록 보기'),
          ),
        ],
      ),
    );
  }
}
