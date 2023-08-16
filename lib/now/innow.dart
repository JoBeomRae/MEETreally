import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/now/nowplus.dart';
import 'package:logger/logger.dart';
import 'package:meet/now/feed.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, userData, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
                top: 50.0, left: 30), // 공간을 두려면 이 줄을 사용하세요.

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
                const SizedBox(height: 20),
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
          floatingActionButton: FloatingActionButton(
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
        );
      },
    );
  }
}
