import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet/my/friend.dart';
import 'package:meet/my/myfeed.dart';
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 추가된 줄
          crossAxisAlignment: CrossAxisAlignment.center, // 변경된 줄

          children: [
            const MyPageTitle(),
            const SizedBox(height: 50),
            ProfileAndUserInfo(
              imageURL: _imageURL,
              userInfo: userInfo,
              pickImage: _pickImage,
            ),
            const SizedBox(height: 20),
            ActionButtons(userInfo: userInfo),
          ],
        ),
      ),
    );
  }
}

class MyPageTitle extends StatelessWidget {
  const MyPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(),
      child: Text(
        '마이페이지',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ProfileAndUserInfo extends StatelessWidget {
  final String? imageURL;
  final Map<String, dynamic>? userInfo;
  final Function()? pickImage;

  const ProfileAndUserInfo(
      {Key? key, this.imageURL, this.userInfo, this.pickImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFE06292),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 88,
                  backgroundImage:
                      imageURL != null ? NetworkImage(imageURL!) : null,
                  backgroundColor: imageURL != null
                      ? null
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => pickImage!(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE06292),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: userInfo != null
                  ? [
                      Text("${userInfo!['nickname']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40)),
                      Text(
                          "${userInfo!['name']} (${userInfo!['age'].toString()}) ${userInfo!['job']}"),
                    ]
                  : [
                      const Text("정보를 가져오는 중..."),
                    ],
            ),
          ),
        ],
      ),
    ));
  }
}

class ActionButtons extends StatelessWidget {
  final Map<String, dynamic>? userInfo;

  const ActionButtons({Key? key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFeedPage(
                    nickname: userInfo!['nickname'],
                  ),
                ),
              );
            },
            child: const Text(
              '내 피드 보러가기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendList(),
                ),
              );
            },
            child: const Text(
              '친구목록 보기',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
