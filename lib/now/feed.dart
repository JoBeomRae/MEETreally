import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meet/now/innow.dart'; // 실제 파일 경로에 맞게 수정하세요.

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피드'),
      ),
      body: Consumer<UserData>(
        builder: (context, userData, child) {
          // NowPlusPage에서 선택된 친구 목록을 가져옴
          List<String>? selectedFriends = userData.friends;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              if (selectedFriends != null && selectedFriends.isNotEmpty) ...[
                // 선택된 친구 목록을 출력
                for (String friend in selectedFriends)
                  InkWell(
                    onTap: () {
                      _showFriendInfoDialog(context, friend); // 친구 정보 다이얼로그 띄우기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        friend,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
              ] else ...[
                // 선택된 친구가 없을 경우 출력
                const Text(
                  '친구를 선택하지 않았습니다.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // 친구 정보 다이얼로그를 띄우는 함수
  void _showFriendInfoDialog(BuildContext context, String friendName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('친구 정보'),
          content: Text('선택한 친구: $friendName'), // 친구의 정보를 여기에 추가
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
