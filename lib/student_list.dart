import 'dart:convert';
import 'dart:io';

import 'package:eguru_v2/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentListScreen extends StatefulWidget {
  StudentListScreen({Key key, this.batchClassroomId}) : super(key: key);
  final batchClassroomId;

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List studentList = [];

  @override
  initState() {
    super.initState();
    getStudentList();
  }

  Future<void> getStudentList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.get(
        Uri.parse("$API_URL/classroom/student-list/${widget.batchClassroomId}"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      var jsonResponse = json.decode(response.body);

      print(jsonResponse);

      if (response.statusCode == 200) {
        setState(() {
          studentList = jsonResponse;
        });
      } else {
        // TDOD: error
      }
    } on Exception catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: studentList.length > 0
          ? ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    elevation: 5.0,
                    child: (ListTile(
                      title: Text(
                          '${studentList[index]['student']['first_name']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${studentList[index]['student']['reference_id']}'),
                    )),
                  ),
                  onTap: () {},
                );
              },
            )
          : Center(child: Text('No records...')),
    );
  }
}
