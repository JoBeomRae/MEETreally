import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/now/nowplus.dart';
import 'package:logger/logger.dart';
import 'package:meet/now/feed.dart';
import 'package:provider/provider.dart';
import 'package:meet/now/find.dart';

var logger = Logger();

class UserData extends ChangeNotifier {
  User? user;
  List<Map<String, dynamic>> allUsersData = [];
  Map<String, dynamic>? userInfo;
  String? si;
  String? gu;
  String? dong;
  List<String>? friends;
  bool isDataFetched = false;

  get icon => null;

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
    allUsersData.add(returnedData);
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
          content: const Text('채팅하기를 누르면 단체 채팅방이 만들어집니다.\n채팅을 하시겠습니까?'),
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
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Expanded(
                  child: ListView.builder(
                    itemCount: userData.allUsersData.length,
                    itemBuilder: (context, index) {
                      final data = userData.allUsersData[index];
                      final si = data['si'] ?? '';
                      final gu = data['gu'] ?? '';
                      final dong = data['dong'] ?? '';
                      final friends = List<String>.from(data['friends'] ?? []);
                      final isCurrentUserData =
                          data['userId'] == userData.user?.uid;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FeedPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          const Text('멤버'),
                                          const SizedBox(height: 10), // 간격 추가

                                          ...friends
                                              .map((friend) => Text(friend))
                                              .toList(),
                                        ],
                                      ),
                                      if (si.isNotEmpty ||
                                          gu.isNotEmpty ||
                                          dong.isNotEmpty) ...[
                                        const SizedBox(height: 20),
                                        Text('지역: $si $gu $dong'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (isCurrentUserData) ...[
                                              ElevatedButton(
                                                onPressed: () {
                                                  _showCallDialog();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 0, 0, 0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text('전화하기'),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _showChatDialog();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 0, 0, 0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text('채팅하기'),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                    MaterialPageRoute(
                      builder: (context) => const FindPage(),
                    ),
                  );
                },
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                child: const Icon(Icons.search,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NowPlusPage(),
                    ),
                  );

                  if (result != null) {
                    // ignore: use_build_context_synchronously
                    Provider.of<UserData>(context, listen: false)
                        .updateUserData(result);

                    final si = userData.allUsersData.last['si'];
                    final gu = userData.allUsersData.last['gu'];
                    final dong = userData.allUsersData.last['dong'];
                    final friends = userData.allUsersData.last['friends'];

                    logger.i(si);
                    logger.i(gu);
                    logger.i(dong);
                    logger.i(friends);

                    await userData.saveToFirestore();
                  }
                },
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                child: const Text(
                  '+',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
