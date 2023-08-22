import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/now/nowplus.dart';
import 'package:logger/logger.dart';
import 'package:meet/now/feed.dart';
import 'package:provider/provider.dart';
import 'package:meet/now/find.dart';

var logger = Logger();

// 1. UserData 모델 클래스 생성
class UserData extends ChangeNotifier {
  User? user;
  Map<String, dynamic>? userInfo;
  String? si;
  String? gu;
  String? dong;
  List<String>? friends;
  bool isDataFetched = false;

  Future<void> fetchUserInfo(User user) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    userInfo = doc.data() as Map<String, dynamic>?;
    notifyListeners();
  }

  Future<void> saveToFirestore() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'si': si,
        'gu': gu,
        'dong': dong,
        'friends': friends,
      });
      notifyListeners();
    }
  }

  void updateUserData(Map<String, dynamic> returnedData) {
    si = returnedData['si'];
    gu = returnedData['gu'];
    dong = returnedData['dong'];
    friends = List<String>.from(returnedData['friends'] ?? []);
    isDataFetched = true;
    notifyListeners();
  }
}

class InNow extends StatefulWidget {
  const InNow({super.key});

  @override
  _InNowPageState createState() => _InNowPageState();
}

class _InNowPageState extends State<InNow> {
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Provider.of<UserData>(context, listen: false).fetchUserInfo(user);
    }
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('전화하기'),
          content: const Text(
              '전화를 하면 등록한 사람에게만 전화가 갑니다.\n또한 전화를 받지 않으면 횟수가 차감되지 않습니다.\n전화를 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 전화하기 기능 구현
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('아니요'),
            ),
          ],
        );
      },
    );
  }

   void _showChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('채팅하기'),
          content: const Text(
              '채팅하기를 누르면 단체 채팅방이 만들어집니다.\n채팅을 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 채팅하기 기능 구현
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('아니요'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '실시간',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (userData.isDataFetched &&
                          userData.userInfo != null) ...[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FeedPage()),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                "멤버: ${userData.friends != null ? userData.friends!.join(', ') : ''}",
                                textAlign: TextAlign.center,
                              ),
                              if (userData.si != null ||
                                  userData.gu != null ||
                                  userData.dong != null) ...[
                                const SizedBox(height: 20),
                                Text(
                                    '지역: ${userData.si ?? ''} ${userData.gu ?? ''} ${userData.dong ?? ''}'),
                               Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: () {
        _showCallDialog(); // 전화하기 기능 구현
      },
      child: const Text('전화하기'),
    ),
    const SizedBox(width: 10),
    ElevatedButton(
      onPressed: () {
        _showChatDialog(); // 채팅하기 기능 구현
      },
      child: const Text('채팅하기'),
    ),
  ],
),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FindPage()), // find.dart 파일에 있는 위젯으로 이동
        );
      },
      child: const Icon(Icons.search), // 돋보기 아이콘 추가
    ),
    const SizedBox(width: 16), // 버튼간의 간격을 조절
    FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NowPlusPage()),
        );

        if (result != null) {
          // ignore: use_build_context_synchronously
          Provider.of<UserData>(context, listen: false)
              .updateUserData(result);

          logger.i(userData.si);
          logger.i(userData.gu);
          logger.i(userData.dong);
          logger.i(userData.friends);

          await userData.saveToFirestore();
        }
      },
      child: const Icon(Icons.add),
    ),
  ],
),

        );
      },
    );
  }
}