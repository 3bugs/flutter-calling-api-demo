import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:calling_api_demo/models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoModel>? _todoList;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALLING API DEMO'),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.pink.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ตัวอย่างการเรียก API: https://jsonplaceholder.typicode.com/todos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _handleClickButton,
                  child: Text('GO!'),
                ),
              ),
              // ใช้ collection if ในการเลือกว่าจะแสดง widget ออกมาหรือไม่ (if นี้ไม่ใช่ statement)
              if (_todoList != null)
                Expanded(
                  child: Stack(
                    children: [
                      if (_todoList != null)
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _todoList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return widget ที่เป็นตัว item ใน list
                            return _buildListItem(index);
                          },
                        ),
                      if (_isLoading) Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleClickButton() async {
    setState(() {
      _isLoading = true; // แสดง progress indicator (หมุนๆ)
    });

    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      // แปลง JSON ไปเป็น data type ของภาษา Dart (list/map)
      // API ตัวนี้ return JSON array ดังนั้นพอทำการ decode response.body แล้วจึงได้เป็น List ไม่ใช่ Map
      var resultList = convert.jsonDecode(response.body);
      print(resultList);

      // บอกให้ Flutter ทำการ rebuild UI หลังจากทำโค้ดข้างใน setState แล้ว
      setState(() {
        // ทำการ map เพื่อแปลงแต่ละ element ใน resultList (ซึ่งแต่ละ element คือ Map type)
        // ไปเป็น model (ถ้าในภาษา Java จะเรียก model แบบนี้ว่า POJO - Plain Old Java Object)
        // ทั้งนี้ การแปลงแต่ละ element จะใช้ factory constructor ที่สร้างไว้ในคลาส TodoModel เอง
        _todoList = resultList
            .map<TodoModel>((item) => TodoModel.fromJson(item))
            .toList();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    setState(() {
      _isLoading = false; // ซ่อน progress indicator
    });
  }

  Widget _buildListItem(int index) {
    TodoModel item = _todoList![index];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(child: Text(item.title)),
            if (item.completed) Icon(Icons.check, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
