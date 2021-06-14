import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eguru_v2/home.dart';
import 'package:eguru_v2/main.dart';
import 'package:eguru_v2/profile.dart';
import 'package:eguru_v2/student_list.dart';
import 'package:eguru_v2/timetable.dart';
import 'package:eguru_v2/complaint_form.dart';
import 'package:eguru_v2/complaint_display.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eguru_v2/config.dart';
import 'package:http/http.dart' as http;

class ClassroomPage extends StatefulWidget {
  ClassroomPage({Key key}) : super(key: key);

  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  List classroomListData = [];
  var userId = '';
  var firstName = '';
  var lastName = '';
  var avatar = '';
  var token = '';

  @override
  initState() {
    super.initState();
    getPref().then((_) => getClassroomData());
    // getStudentList();
  }

  Future getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      firstName = prefs.getString('firstName');
      lastName = prefs.getString('lastName');
      avatar = prefs.getString('avatar');
    });
  }

  Future<void> getClassroomData() async {
    try {
      var response = await http.get(
        Uri.parse("$API_URL/classroom"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      var jsonResponse = json.decode(response.body);

      print(jsonResponse);

      if (response.statusCode == 200) {
        setState(() {
          classroomListData = jsonResponse;
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
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Text('Classroom'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
            ),
          ],
        ),
        body: classroomListData.length > 0
            ? ListView.builder(
                itemCount: classroomListData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: (ListTile(
                        title: Text(
                            '${classroomListData[index]['batch']['batch']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${classroomListData[index]['classroom']['classroom_name']}'),
                      )),
                    ),
                    onTap: () {
                      var batchClassroomId = classroomListData[index]['id'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentListScreen(
                              batchClassroomId: batchClassroomId,
                            ),
                          ));
                    },
                  );
                },
              )
            : Center(child: Text('No records...')),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: [
                    avatar != null || avatar != ''
                        ? CachedNetworkImage(
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              );
                            },
                            imageUrl: '$AVATAR_URL/$avatar',
                            placeholder: (context, url) => Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 96,
                              ),
                            ),
                          )
                        : Icon(Icons.account_box_rounded),
                    Text('$firstName $lastName',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decorationStyle: TextDecorationStyle.wavy,
                        )),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                ),
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.account_circle,
              //     size: 20.0,
              //   ),
              //   title: Text('Profile'),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     // Navigator.pop(context);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => ProfileScreen(),
              //       ),
              //     );
              //   },
              // ),
              const Divider(
                height: 5,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              ListTile(
                leading: const Icon(
                  Icons.dashboard,
                  size: 20.0,
                ),
                title: Text('Dashboard'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.qr_code_scanner,
              //     size: 20.0,
              //   ),
              //   title: Text('QR Code'),
              //   onTap: () {
              //     // Update the state of the app
              //     // ...
              //     // Then close the drawer
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                leading: const Icon(
                  Icons.view_list,
                  size: 20.0,
                ),
                title: Text('Attandee list'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassroomPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  size: 20.0,
                ),
                title: Text('Timetable'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimetableScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.feedback,
                  size: 20.0,
                ),
                title: Text('Feedback'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintForm(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.history,
                  size: 20.0,
                ),
                title: Text('Feedback History'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintHistory(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
