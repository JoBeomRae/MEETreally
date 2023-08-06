import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String _selectedCity = '';

  final List<String> _cityOptions = <String>[
    '서울특별시',
    '부산광역시',
    // 추가로 다른 시/도를 넣어주시면 됩니다.
  ];

  final TextEditingController _guController = TextEditingController();
  final TextEditingController _dongController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _guController.dispose();
    _dongController.dispose();
    _peopleController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('시를 입력하세요 (필수)'),
              trailing: DropdownButton<String>(
                value: _selectedCity.isEmpty ? null : _selectedCity,
                hint: const Text('Select city'),
                items:
                    _cityOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue!;
                  });
                },
              ),
            ),
            TextField(
              controller: _guController,
              decoration: const InputDecoration(
                hintText: '구 : 구를 입력하세요. (선택)',
              ),
            ),
            TextField(
              controller: _dongController,
              decoration: const InputDecoration(
                hintText: '동 : 동을 입력하세요. (선택)',
              ),
            ),
            TextField(
              controller: _peopleController,
              decoration: const InputDecoration(
                hintText: '인원 : 인원을 선택하세요. (필수)',
              ),
            ),
            TextField(
              controller: _placeController,
              decoration: const InputDecoration(
                hintText: '만나는 곳 : 원하는 장소를 선택해주세요 (선택)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
