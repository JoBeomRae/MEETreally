import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('친구 관리')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('friends').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final friends = snapshot.data!.docs;
          List<Widget> friendWidgets = friends.map((doc) {
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
            );
          }).toList();

          return ListView(children: friendWidgets);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFriendDialog(context),
        child: const Icon(Icons.add),
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

                if (snapshot.docs.isNotEmpty) {
                  final user = snapshot.docs.first;
                  final userData = user.data() as Map<String, dynamic>;

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  _showConfirmFriendDialog(context, userData);
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
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
                await _firestore.collection('friends').add({
                  'nickname': userData['nickname'],
                  'name': userData['name'],
                  'age': userData['age'],
                  'job': userData['job'],
                });

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
