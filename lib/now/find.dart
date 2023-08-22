import 'package:flutter/material.dart';
import 'package:meet/now/innow.dart';


class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final TextEditingController _siController = TextEditingController();
  final TextEditingController _guController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final List<TextEditingController> _controllers = [];
  final _formKey = GlobalKey<FormState>();
  bool _enableSubmitButton = false;

  Map<String, Map<String, List<String>>> locations = {
    '서울특별시': {
      '종로구': ['청운동', '효자동', '사직동'],
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

void _checkInputValid() {
  setState(() {
    _enableSubmitButton = (selectedSi != null &&
        selectedGu != null &&
        selectedPeopleCount != null);
  });
}

    @override
  void initState() {
    super.initState();
    _siController.addListener(_checkInputValid);
    _guController.addListener(_checkInputValid);
    _personController.addListener(_checkInputValid);
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
            padding: const EdgeInsets.only(top: 24.0),  // 이 부분을 추가합니다.
    child: Padding(
        padding: const EdgeInsets.all(16.0),
       child: Form(
            key: _formKey,
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
                    _checkInputValid(); // 변경사항이 있으면 버튼 활성화 여부 검사
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
                    _checkInputValid(); // 변경사항이 있으면 버튼 활성화 여부 검사
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
                    _checkInputValid(); // 변경사항이 있으면 버튼 활성화 여부 검사
                  });
                },
                hint: const Text('함께할 친구 수를 선택해주세요.(필수)'),
              ),
            ),
            const SizedBox(height: 16),
            
            // 등록하기 버튼
         ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _enableSubmitButton
                    ? () {
                        // ignore: unused_local_variable
                        var dataToReturn = {
                          'si': selectedSi,
                          'gu': selectedGu,
                          'dong': selectedDong,
                          'friends':
                              _controllers.map((e) => e.text).toList(),
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InNow(),
                          ),
                        );
                      }
                    : null, // 버튼 비활성화
                child: const Text('찾아보기'),
              ),
           ] 
           ),
          ),
        ),
      ),
    );
  }
}
