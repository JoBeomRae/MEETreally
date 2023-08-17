import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet/my/friend.dart';
import 'package:meet/my/myfeed.dart'; // <-- 추가한 코드
import 'package:logger/logger.dart';

final logger = Logger();

class InMy extends StatefulWidget {
  const InMy({Key? key}) : super(key: key);

  @override
  _InMyState createState() => _InMyState();
}

class _InMyState extends State<InMy> {
  User? user;
  Map<String, dynamic>? userInfo;
  String? _imageURL;

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
      _imageURL = userInfo!['imageURL'];
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = 'profile_${user!.uid}';
      await _uploadImage(imageFile, fileName);
    }
  }

  Future<void> _uploadImage(File imageFile, String fileName) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_images').child(fileName);
    final UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      String downloadURL = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'imageURL': downloadURL});
      setState(() {
        _imageURL = downloadURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50.0, left: 30.0), // 여기에 left를 추가하세요.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '마이페이지',
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
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageURL != null
                        ? NetworkImage(_imageURL!)
                        : null, // 기본 이미지를 제거하고 아래의 자식 위젯을 사용
                    backgroundColor: Colors.black, // 원하는 색상으로 설정
                    child: _imageURL == null
                        ? GestureDetector(
                            onTap: _pickImage, // 아이콘을 눌렀을 때 _pickImage 메소드 호출
                            child: const Icon(
                              Icons.add, // '+' 아이콘
                              size: 40, // 아이콘 크기
                              color: Colors.white, // 아이콘 색상
                            ),
                          )
                        : null, // 이미지 URL이 있을 경우 아이콘을 표시하지 않음
                  ),
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
                          builder: (context) => MyFeedPage(
                            nickname: userInfo!['nickname'], // 수정된 코드
                          ),
                        ),
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
