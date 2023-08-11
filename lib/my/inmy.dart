import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/my/friend.dart';

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

    // 로그인한 경우 Firestore에서 사용자 정보 가져오기
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
            Text("닉네임: ${userInfo!['nickname']}"), // 닉네임 추가

            Text("이름: ${userInfo!['name']}"),
            Text("나이: ${userInfo!['age'].toString()}"),
            Text("직업: ${userInfo!['job']}"),
          ] else ...[
            const Text("정보를 가져오는 중..."),
          ],
          const SizedBox(height: 20), // Add some space
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendList()),
              );
            },
            child: const Text('친구목록 보기'),
          )
        ],
      ),
    );
  }
}
