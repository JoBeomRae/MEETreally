import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meet/now/innow.dart'; // 실제 파일 경로에 맞게 수정하세요.
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
        backgroundColor: Colors.white, // 앱바 배경색을 흰색으로 설정
        elevation: 0, // 그림자 제거
        automaticallyImplyLeading: false, // 뒤로가기 버튼 자동 추가 비활성화
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.black), // 검은색 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 화면 닫기
          },
        ),
      ),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Consumer<UserData>(
        builder: (context, userData, child) {
          // NowPlusPage에서 선택된 친구 목록을 가져옴
          List<String>? selectedFriends = userData.friends;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (selectedFriends != null && selectedFriends.isNotEmpty) ...[
                // 선택된 친구 목록을 출력
                for (int i = 0; i < selectedFriends.length; i++)
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyFeedPage(
                                  nickname:
                                      extractNickname(selectedFriends[i])),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/dlstmxk.png', // 이미지 경로를 적절히 수정
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(width: 50),
                              Text(
                                extractNickname(selectedFriends[i]),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (i !=
                          selectedFriends.length -
                              1) // 마지막 친구 아이템 후에는 구분선 추가 안 함
                        const Divider(
                          color: Color.fromARGB(255, 105, 86, 86),
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                    ],
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
}
