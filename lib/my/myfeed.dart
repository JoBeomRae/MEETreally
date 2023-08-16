import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:photo_view/photo_view.dart'; // 추가

class MyFeedPage extends StatefulWidget {
  const MyFeedPage({Key? key}) : super(key: key);

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  User? user;
  Map<String, dynamic>? userInfo;
  File? _image;
  final picker = ImagePicker();
  final List<String> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserInfo(user!);
    }
    loadUploadedImages();
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

  Future loadUploadedImages() async {
    var images = await FirebaseFirestore.instance
        .collection('uploaded_images')
        .doc(user!.uid)
        .get();
    if (images.data() != null) {
      setState(() {
        uploadedImages.addAll(List<String>.from(images.data()!['images']));
      });
    }
  }

  Future getImageAndUpload() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await resizeImage(_image!, 600, 600);
      await uploadImageToFirebase();
    } else {
      // ignore: avoid_print
      print('No image selected.');
    }
  }

  Future uploadImageToFirebase() async {
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image selected')));
      return;
    }

    String fileName = _image!.path.split('/').last;

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("uploads/$fileName");
    UploadTask uploadTask = ref.putFile(_image!);

    await uploadTask.then((res) async {
      String imageUrl = await res.ref.getDownloadURL();
      uploadedImages.add(imageUrl);
      await FirebaseFirestore.instance
          .collection('uploaded_images')
          .doc(user!.uid)
          .set({'images': uploadedImages});
      setState(() {});
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Uploaded Successfully')));
    });
  }

  Future resizeImage(File file, int width, int height) async {
    img.Image originalImage = img.decodeImage(file.readAsBytesSync())!;

    img.Image resizedImage =
        img.copyResize(originalImage, width: width, height: height);

    await file.writeAsBytes(img.encodeJpg(resizedImage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                // Row 위젯 추가
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20), // 아이콘과 텍스트 사이의 간격
                  if (userInfo != null) ...[
                    const Text(
                      "My Feed",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0), // 여기에 패딩을 추가하였습니다.
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0, // 세로 축 간격을 조절하였습니다.
                    crossAxisSpacing: 8.0, // 가로 축 간격을 조절하였습니다.
                  ),
                  itemCount: uploadedImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageDetailPage(uploadedImages[index]),
                          ),
                        );
                      },
                      child: Image.network(uploadedImages[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageAndUpload,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  const ImageDetailPage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // 배경색을 흰색으로 설정
        body: Center(
          child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: const BoxDecoration(
// 배경색 설정
                color: Colors.white,
              )),
        ));
  }
}
