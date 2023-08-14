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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '마이페이지', // "마이페이지" 텍스트 추가
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/rlagusrb.png'),
                  const SizedBox(height: 20),
                  if (userInfo != null) ...[
                    Text("${userInfo!['nickname']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40)),
                    Text(
                        "${userInfo!['name']} (${userInfo!['age'].toString()})"),
                    Text("${userInfo!['job']}"),
                  ] else ...[
                    const Text("정보를 가져오는 중..."),
                  ],
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyFeedPage()),
                      );
                    },
                    child: const Text(
                      '내 피드 보러가기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendList()),
                      );
                    },
                    child: const Text(
                      '친구목록 보기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
