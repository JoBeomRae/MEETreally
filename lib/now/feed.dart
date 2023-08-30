import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meet/now/innow.dart'; // 실제 파일 경로에 맞게 수정하세요.
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/my/myfeed.dart'; // 실제 파일 경로에 맞게 수정하세요.

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  String extractNickname(String fullName) {
    int idx = fullName.indexOf('(');
    if (idx != -1) {
      return fullName.substring(0, idx).trim();
    } else {
      return fullName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<UserData>(
        builder: (context, userData, child) {
          List<String>? selectedFriends = userData.friends;

          if (selectedFriends == null || selectedFriends.isEmpty) {
            return const Center(
              child: Text(
                '친구를 선택하지 않았습니다.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    "Feed 보러가기",
                    style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedFriends.length,
                  itemBuilder: (context, index) {
                    String friend = selectedFriends[index];
                    String friendNickname = extractNickname(friend);

                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('nickname', isEqualTo: friendNickname)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            Map<String, dynamic> data = snapshot.data!.docs[0]
                                .data() as Map<String, dynamic>;

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyFeedPage(
                                            nickname: friendNickname),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 50),
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(data['imageURL']),
                                          radius: 40,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          friendNickname,
                                          style: const TextStyle(fontSize: 40),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (index != selectedFriends.length - 1)
                                  const Divider(
                                    color: Color.fromARGB(255, 105, 86, 86),
                                    height: 1,
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                              ],
                            );
                          } else {
                            return const ListTile(
                              leading: CircleAvatar(),
                              title: Text('User not found'),
                            );
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
