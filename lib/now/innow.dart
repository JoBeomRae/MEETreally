import 'package:flutter/material.dart';
import 'package:meet/now/nowplus.dart';

class InNow extends StatefulWidget {
  final String? si;
  final String? gu;
  final String? dong;
  final List<String?>? friends;

  const InNow({
    Key? key,
    this.si,
    this.gu,
    this.dong,
    this.friends,
  }) : super(key: key);

  @override
  _InNowPageState createState() => _InNowPageState();
}

class _InNowPageState extends State<InNow> {
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        '실시간',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('시: ${widget.si ?? '선택되지 않음'}'),
          Text('구: ${widget.gu ?? '선택되지 않음'}'),
          Text('동: ${widget.dong ?? '선택되지 않음'}'),
          const SizedBox(height: 16),
          const Text('친구들:'),
          ...?widget.friends?.map((friend) => Text(friend ?? '이름 없음')),
        ],
      ),
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
