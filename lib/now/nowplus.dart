import 'package:flutter/material.dart';
import 'package:meet/now/innow.dart';

class NowPlusPage extends StatefulWidget {
  const NowPlusPage({Key? key}) : super(key: key);

  @override
  _NowPlusPageState createState() => _NowPlusPageState();
}

class _NowPlusPageState extends State<NowPlusPage> {
  final TextEditingController _siController = TextEditingController();
  final TextEditingController _guController = TextEditingController();
  final TextEditingController _personController = TextEditingController();

  Map<String, List<String>> locations = {
    '서울특별시': [
      '종로구', '중구', '용산구', '성동구', '광진구', '동대문구',
    ],
    '부산광역시': [
      '읍부', '면부', '동부', '중구', '서구', '동구',
    ],
  };

  String? selectedSi; 
  List<String>? selectedGuList; 
  String? selectedGu; 
  String? selectedPeople;
  int? selectedPeopleCount; // 선택된 인원 수

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
            DropdownButton<String>(
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
            const SizedBox(height: 16),

            // 구
            DropdownButton<String>(
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
            const SizedBox(height: 16),

            // 동


            // 인원
DropdownButton<int>(
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
const SizedBox(height: 16),

Column(
  children: selectedPeopleCount != null 
    ? List.generate(selectedPeopleCount!, (int index) {
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '${index + 1}번째 사람',
                hintText: '이름을 입력해주세요.',
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      })
    : [], // 만약 선택된 인원 수가 없다면 빈 리스트를 반환
),




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
