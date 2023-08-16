import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NowPlusPage extends StatefulWidget {
  const NowPlusPage({Key? key}) : super(key: key);

  @override
  _NowPlusPageState createState() => _NowPlusPageState();
}

class _NowPlusPageState extends State<NowPlusPage> {
  final TextEditingController _siController = TextEditingController();
  final TextEditingController _guController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final List<TextEditingController> _controllers = [];

  Map<String, Map<String, List<String>>> locations = {
    '서울특별시': {
      '종로구': ['청운동', '효자동', '사직동'], // 예시 동 데이터입니다. 원하는대로 수정하세요.
      '중구': ['을지로동', '명동', '필동'],
    },
    '부산광역시': {
      '읍부': ['동1', '동2'],
    },
  };

  String? selectedSi;
  List<String>? selectedGuList;
  String? selectedGu;
  String? selectedPeople;
  int? selectedPeopleCount;
  String? selectedDong;
  List<String>? selectedDongList;

  void _showFriendPicker(int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth
                          .instance.currentUser?.uid) // 현재 사용자의 ID를 가져옵니다.
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final userNickname = userData['nickname'];
                    final userAge = userData['age'];
                    final userJob = userData['job'];

                    return ListTile(
                      title: Text('$userNickname ($userAge, $userJob)'),
                      onTap: () {
                        setState(() {
                          _controllers[index].text =
                              '$userNickname ($userAge, $userJob)';
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('friends')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final friends = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, position) {
                          final friendData =
                              friends[position].data() as Map<String, dynamic>;

                          final nickname = friendData['nickname'];
                          final age = friendData['age'];
                          final job = friendData['job'];

                          return ListTile(
                            title: Text('$nickname ($age, $job)'),
                            onTap: () {
                              setState(() {
                                _controllers[index].text =
                                    '$nickname ($age, $job)';
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _siController.dispose();
    _guController.dispose();
    _personController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 뒤로 가기 버튼 추가
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // 시
            Center(
              child: DropdownButton<String>(
                value: selectedSi,
                items: locations.keys.map((String si) {
                  return DropdownMenuItem<String>(
                    value: si,
                    child: Text(si),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSi = newValue;
                    _siController.text = newValue!;
                    selectedGuList = locations[newValue]?.keys.toList();
                    selectedGu = null;
                    _guController.text = '';
                  });
                },
                hint: const Text('시를 선택해주세요.(필수)'),
              ),
            ),
            const SizedBox(height: 16),
            // 구
            Center(
              child: DropdownButton<String>(
                value: selectedGu,
                items: selectedGuList?.map((String gu) {
                  return DropdownMenuItem<String>(
                    value: gu,
                    child: Text(gu),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGu = newValue;
                    _guController.text = newValue!;
                    selectedDongList = locations[selectedSi]?[newValue];
                    selectedDong = null; // 동 선택 초기화
                  });
                },
                hint: const Text('구를 선택해주세요.(필수)'),
              ),
            ),
            const SizedBox(height: 16),
// 동
            Center(
              child: DropdownButton<String>(
                value: selectedDong,
                items: selectedDongList?.map((String dong) {
                  return DropdownMenuItem<String>(
                    value: dong,
                    child: Text(dong),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDong = newValue;
                  });
                },
                hint: const Text('동을 선택해주세요.(선택)'),
              ),
            ),
            const SizedBox(height: 16),
            // 인원
            Center(
              child: DropdownButton<int>(
                value: selectedPeopleCount,
                items: [1, 2, 3].map((int person) {
                  return DropdownMenuItem<int>(
                    value: person,
                    child: Text('$person명'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedPeopleCount = newValue;
                    _personController.text = '$newValue명';
                  });
                },
                hint: const Text('함께할 친구 수를 선택해주세요.(필수)'),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: selectedPeopleCount != null
                  ? List.generate(selectedPeopleCount!, (int index) {
                      while (_controllers.length <= index) {
                        _controllers.add(TextEditingController());
                      }
                      return Column(
                        children: [
                          // 변경 후
                          Container(
                            height: 50, // 원하는 높이로 조절하세요.
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showFriendPicker(index);
                              },
                              child: AbsorbPointer(
                                child: _controllers[index]
                                        .text
                                        .isEmpty // 해당 인덱스의 컨트롤러의 텍스트가 비어있다면 힌트 텍스트를 표시
                                    ? const Center(child: Text("친구를 선택해주세요."))
                                    : TextField(
                                        controller: _controllers[index],
                                        decoration: InputDecoration(
                                          border: InputBorder
                                              .none, // 기존의 border를 제거
                                          labelText: '${index + 1}번째 친구',
                                          hintText: '닉네임을 입력해주세요.',
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    })
                  : [],
            ),
            // 등록하기 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                var dataToReturn = {
                  'si': selectedSi,
                  'gu': selectedGu,
                  'dong': selectedDong,
                  'friends': _controllers.map((e) => e.text).toList(),
                };

                Navigator.pop(context, dataToReturn);
              },
              child: const Text('등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}
