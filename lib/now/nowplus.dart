import 'package:flutter/material.dart';
import 'package:meet/now/innow.dart';
import 'package:meet/my/friend.dart';

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

  Map<String, List<String>> locations = {
    '서울특별시': ['종로구', '중구', '용산구', '성동구', '광진구', '동대문구'],
    '부산광역시': ['읍부', '면부', '동부', '중구', '서구', '동구'],
  };

  String? selectedSi;
  List<String>? selectedGuList;
  String? selectedGu;
  String? selectedPeople;
  int? selectedPeopleCount;

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
                    selectedGuList = locations[newValue];
                    selectedGu = null;
                    _guController.text = '';
                  });
                },
                hint: const Text('시를 선택해주세요.'),
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
                  });
                },
                hint: const Text('구를 선택해주세요.(선택)'),
              ),
            ),
            const SizedBox(height: 16),
            // 인원
            Center(
              child: DropdownButton<int>(
                value: selectedPeopleCount,
                items: [2, 3, 4].map((int person) {
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
                hint: const Text('인원을 선택해주세요.'),
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
                          GestureDetector(
                            onTap: () async {
                              final selectedNickname =
                                  await Navigator.of(context).push<String>(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const FriendList(),
                                ),
                              );
                              if (selectedNickname != null &&
                                  selectedNickname.isNotEmpty) {
                                setState(() {
                                  _controllers[index].text = selectedNickname;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _controllers[index],
                                decoration: InputDecoration(
                                  labelText: '${index + 1}번째 친구',
                                  hintText: '닉네임을 입력해주세요.',
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
