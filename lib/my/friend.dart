// friend.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final TextEditingController _nicknameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserID = "YOUR_CURRENT_USER_ID"; // 현재 로그인한 사용자의 ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구목록'),
      ),
      body: const Center(
        child: Text('친구 목록을 여기에 표시합니다!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFriendDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

   _showAddFriendDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("닉네임을 입력하세요"),
          content: TextField(controller: _nicknameController),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () async {
                QuerySnapshot snapshot = await _firestore
                    .collection('users')
                    .where('nickname', isEqualTo: _nicknameController.text)
                    .get();

                if (snapshot.docs.isNotEmpty) {
                  final userInfo = snapshot.docs.first.data() as Map<String, dynamic>;

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context); // 첫 번째 대화상자 닫기

                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("사용자 정보"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("이름: ${userInfo['name']}"),
                            Text("나이: ${userInfo['age'].toString()}"),
                            Text("직업: ${userInfo['job']}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("친구추가"),
                            onPressed: () async {
                              // Firestore에 친구 요청 저장
                              await _firestore.collection('friend_requests').add({
                                'from': currentUserID,
                                'to': snapshot.docs.first.id,
                              });
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context); // 현재 대화상자 닫기
                            },
                          ),
                          TextButton(
                            child: const Text("취소"),
                            onPressed: () {
                              Navigator.pop(context); // 대화상자 닫기
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("해당 닉네임의 사용자를 찾을 수 없습니다.")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
