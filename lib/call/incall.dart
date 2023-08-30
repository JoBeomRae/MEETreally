import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InCall extends StatefulWidget {
  const InCall({super.key});

  @override
  _InCallState createState() => _InCallState();
}

class _InCallState extends State<InCall> {
  User? user;
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserProfilePicture(user!);
    }
  }

  Future<void> fetchUserProfilePicture(User user) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _imageURL = doc['imageURL'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _imageURL != null
            ? Image.network(_imageURL!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
