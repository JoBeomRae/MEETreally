import 'package:flutter/material.dart';
import 'package:meet/firstloginpage/first_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedPeople;
  int _numberOfPeople = 0;

  final List<String> _cities = ['서울특별시', '부산광역시'];
  final Map<String, List<String>> _districts = {
    '서울특별시': ['강남구', '서초구'],
    '부산광역시': ['부산구', '구구']
  };
  final List<String> _people = ['2명', '3명', '4명'];

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
            DropdownButton<String>(
              value: _selectedCity,
              hint: const Text('시를 선택하세요. (필수)'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                  _selectedDistrict = null;
                });
              },
              items: _cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: _selectedDistrict,
              hint: const Text('구를 선택하세요. (선택)'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
              items: _selectedCity == null
                  ? []
                  : _districts[_selectedCity]!
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
            ),
            DropdownButton<String>(
              value: _selectedPeople,
              hint: const Text('인원을 선택하세요. (필수)'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPeople = newValue;
                  _numberOfPeople = int.parse(newValue![0]);
                });
              },
              items: _people.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            for (var i = 0; i < _numberOfPeople; i++)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nickname ${i + 1}',
                  hintText: 'Enter name of Nickname ${i + 1}',
                ),
              ),
            ElevatedButton(
              child: const Text("등록하기"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirstPage(
                      city: _selectedCity,
                      district: _selectedDistrict,
                      people: _selectedPeople,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
