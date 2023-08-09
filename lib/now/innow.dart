import 'package:flutter/material.dart';
import 'package:meet/now/nowplus.dart';

class InNow extends StatefulWidget {
  const InNow({super.key});

  @override
  _InNowPageState createState() => _InNowPageState();
}

class _InNowPageState extends State<InNow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InNow'),
      ),
      body: const Center(
        child: Text('InNow Page Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NowPlusPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
