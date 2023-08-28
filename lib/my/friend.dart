import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendInfo {
  final String nickname;
  final String name;
  final int age;
  final String job;

  FriendInfo({
    required this.nickname,
    required this.name,
    required this.age,
    required this.job,
  });
}

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nicknameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FriendInfo? loggedInUser;

  @override
  void initState() {
    super.initState();
    _fetchLoggedInUserInfo();
  }

  _fetchLoggedInUserInfo() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          final data = userDoc.data()!;
          final ageString = data['age'] ?? '0';

          loggedInUser = FriendInfo(
            nickname: data['nickname'],
            name: data['name'],
            age: int.tryParse(ageString) ?? 0,
            job: data['job'],
          );
        });
      }
    }
  }

  Future<void> _showUserInfoDialog(
      BuildContext context, Map<String, dynamic> userInfo) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("사용자 정보"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("닉네임: ${userInfo['nickname']}"),
              Text("이름: ${userInfo['name']}"),
              Text("나이: ${userInfo['age']}"),
              Text("직업: ${userInfo['job']}"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: null,
        body: Column(
          children: [
            const SizedBox(height: 70), // 여기에 간격을 추가
            if (loggedInUser != null) ...[
              ListTile(
                title: Text('닉네임: ${loggedInUser!.nickname}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름: ${loggedInUser!.name}'),
                    Text('나이: ${loggedInUser!.age}'),
                    Text('직업: ${loggedInUser!.job}'),
                  ],
                ),
                onTap: () {
                  _showUserInfoDialog(context, {
                    'nickname': loggedInUser!.nickname,
                    'name': loggedInUser!.name,
                    'age': loggedInUser!.age.toString(),
                    'job': loggedInUser!.job,
                  });
                },
              ),
              const Divider(color: Colors.grey), // 회색 선 추가
            ],
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('friends').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final friends = snapshot.data!.docs;
                  List<Widget> friendWidgets =
                      friends.map((doc) => _buildFriendItem(doc)).toList();

                  return ListView(children: friendWidgets);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFriendDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ListTile _buildFriendItem(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ListTile(
      title: Text('닉네임: ${data['nickname']}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이름: ${data['name']}'),
          Text('나이: ${data['age']}'),
          Text('직업: ${data['job']}'),
        ],
      ),
      onTap: () {
        _showUserInfoDialog(context, data);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // 친구 정보 수정 로직
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _firestore.collection('friends').doc(doc.id).delete();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAddFriendDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("닉네임을 입력하세요"),
          content: TextField(controller: _nicknameController),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () async {
                final nickname = _nicknameController.text;
                QuerySnapshot snapshot = await _firestore
                    .collection('users')
                    .where('nickname', isEqualTo: nickname)
                    .get();

                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                if (snapshot.docs.isNotEmpty) {
                  final user = snapshot.docs.first;
                  final userData = user.data() as Map<String, dynamic>;
                  // ignore: use_build_context_synchronously
                  _showConfirmFriendDialog(context, userData);
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('해당 닉네임의 사용자를 찾을 수 없습니다.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmFriendDialog(
      BuildContext context, Map<String, dynamic> userData) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("사용자 정보 확인"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("닉네임: ${userData['nickname']}"),
              Text("이름: ${userData['name']}"),
              Text("나이: ${userData['age']}"),
              Text("직업: ${userData['job']}"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("친구추가"),
              onPressed: () async {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore
                      .collection('users')
                      .doc(user.uid)
                      .collection('friends')
                      .add(userData);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
