import 'package:calling_api_demo/models/TodoModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoModel>? _todoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALLING API DEMO'),
      ),
      body: Container(
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _todoList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    TodoModel item = _todoList![index];

                    // return widget ที่เป็นตัว item ใน list
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.title)),
                            if (item.completed)
                              Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleClickButton() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      // แปลง JSON ไปเป็น Dart's data structure (list/map)
      // API ตัวนี้ return JSON array ดังนั้นพอทำการ decode response.body แล้วจึงได้เป็น List ไม่ใช่ Map
      var resultList = convert.jsonDecode(response.body);
      print(resultList);

      // แปลง Dart's data structure ไปเป็น model (ถ้าในภาษา Java จะเรียก POJO - Plain Old Java Object)
      // โดยใช้ factory constructor ที่สร้างไว้ในคลาส TodoModel
      _todoList = resultList.map((item) => TodoModel.fromJson(item)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
