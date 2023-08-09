import 'package:flutter/material.dart';
import 'package:meet/now/innow.dart';

class NowPlusPage extends StatefulWidget {
  const NowPlusPage({super.key});

  @override
  _NowPlusPageState createState() => _NowPlusPageState();
}

class _NowPlusPageState extends State<NowPlusPage> {
  final TextEditingController _siController = TextEditingController();
  final TextEditingController _guController = TextEditingController();
  final TextEditingController _dongController = TextEditingController();
  final TextEditingController _personController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NowPlus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 시
            TextField(
              controller: _siController,
              decoration: const InputDecoration(
                labelText: '시',
                hintText: '시를 선택해주세요. (필수)',
              ),
            ),
            const SizedBox(height: 16),

            // 구
            TextField(
              controller: _guController,
              decoration: const InputDecoration(
                labelText: '구',
                hintText: '구를 선택해주세요. (선택)',
              ),
            ),
            const SizedBox(height: 16),

            // 동
            TextField(
              controller: _dongController,
              decoration: const InputDecoration(
                labelText: '동',
                hintText: '동을 선택해주세요. (선택)',
              ),
            ),
            const SizedBox(height: 16),

            // 인원
            TextField(
              controller: _personController,
              decoration: const InputDecoration(
                labelText: '인원',
                hintText: '인원을 선택해주세요. (필수)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // 등록하기 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InNow()),
                );
              },
              child: const Text('등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}