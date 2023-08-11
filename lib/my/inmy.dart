import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet/my/friend.dart';
import 'package:image_picker/image_picker.dart'; // <-- 추가한 코드
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
  // ignore: unused_field
  File? _image; // 선택한 이미지를 저장하는 변수

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

  // 사진을 선택하는 메서드
  // ignore: unused_element
  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        _image = File('path_to_default_image');
        logger.i('No image selected. Default image set.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null)
            Image.file(_image!,
                width: 150, height: 150, fit: BoxFit.cover), // 추가: 선택된 이미지 표시
          const SizedBox(height: 20), // Add some space between image and info

          if (userInfo != null) ...[
            Text("닉네임: ${userInfo!['nickname']}"),
            Text("이름: ${userInfo!['name']}"),
            Text("나이: ${userInfo!['age'].toString()}"),
            Text("직업: ${userInfo!['job']}"),
          ] else ...[
            const Text("정보를 가져오는 중..."),
          ],

          const SizedBox(height: 20),

          MaterialButton(
            color: Colors.orange, // 버튼 색상 변경
            onPressed: _pickImage, // 버튼 클릭 시 이미지 선택 메서드 호출
            child: const Text('이미지 선택하기'), // 버튼 텍스트 변경
          ),

          const SizedBox(height: 20),

          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendList()),
              );
            },
            child: const Text('친구목록 보기'),
          ),
        ],
      ),
    );
  }
}
