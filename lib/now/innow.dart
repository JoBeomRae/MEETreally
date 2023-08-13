import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/now/nowplus.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class InNow extends StatefulWidget {
  const InNow({super.key});

  @override
  _InNowPageState createState() => _InNowPageState();
}

class _InNowPageState extends State<InNow> {
  User? user;
  Map<String, dynamic>? userInfo; // 로그인한 사용자의 정보를 저장하는 변수
  String? si;
  String? gu;
  String? dong;
  List<String>? friends;

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
      appBar: AppBar(
        title: const Text('InNow'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (userInfo != null) ...[
              Text(
                "멤버: ${userInfo!['nickname']} (${userInfo!['age']}, ${userInfo!['job']})"
                "${friends != null && friends!.isNotEmpty ? ', ${friends!.join(', ')}' : ''}",
                textAlign: TextAlign.center,
              ),
            ],
            if (si != null || gu != null || dong != null) ...[
              const SizedBox(height: 20),
              Text('지역: ${si ?? ''} ${gu ?? ''} ${dong ?? ''}'),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NowPlusPage()),
          );

          if (result != null) {
            Map<String, dynamic> returnedData = result;

            setState(() {
              si = returnedData['si'];
              gu = returnedData['gu'];
              dong = returnedData['dong'];
              friends = List<String>.from(returnedData['friends'] ?? []);
            });

            logger.i(si);
            logger.i(gu);
            logger.i(dong);
            logger.i(friends);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
