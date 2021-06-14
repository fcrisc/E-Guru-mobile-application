import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eguru_v2/main.dart';
import 'package:eguru_v2/models/student.dart';
import 'package:eguru_v2/classroom.dart';
import 'package:eguru_v2/profile.dart';
import 'package:eguru_v2/timetable.dart';
import 'package:eguru_v2/complaint_form.dart';
import 'package:eguru_v2/complaint_display.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eguru_v2/config.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> studentList = [];
  var userId = '';
  var firstName = '';
  var lastName = '';
  var avatar = '';
  var token = '';

  @override
  initState() {
    super.initState();
    getPref().then((_) => getStudentList());
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

  Future<void> getStudentList() async {
    try {
      var response = await http.get(
        Uri.parse("$API_URL/student"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      var jsonResponse = json.decode(response.body);

      if (jsonResponse['data'] == null) {
        // error
      } else {
        setState(() {
          for (int i = 0; i < jsonResponse['data'].length; i++) {
            studentList.add(Student.fromasdasdasdasd(jsonResponse['data'][i]));
          }
        });
      }
    } on Exception catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Dashboard'),
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
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Icon(
                //   Icons.volunteer_activism,
                //   color: Colors.pinkAccent.shade400,
                //   size: 52.0,
                // ),
                Icon(
                  Icons.volunteer_activism,
                  color: Colors.pinkAccent.shade400,
                  size: 52.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "The influence of a \ngood teacher \ncan never be \nerased",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20.0,
                children: <Widget>[
                  SizedBox(
                    width: 160.0,
                    height: 160.0,
                    child: Card(
                      color: Color.fromARGB(255, 21, 21, 21),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.notifications,
                              size: 64.0,
                              color: Colors.yellow.shade300,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Alarmed",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w100),
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 160.0,
                    height: 160.0,
                    child: Card(
                      color: Color.fromARGB(255, 21, 21, 21),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.schedule,
                              size: 64.0,
                              color: Colors.blue.shade300,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Timetable",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 160.0,
                    height: 160.0,
                    child: Card(
                      color: Color.fromARGB(255, 21, 21, 21),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/e-guru-icon.png",
                              width: 64.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Attendee",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 160.0,
                    height: 160.0,
                    child: Card(
                      color: Color.fromARGB(255, 21, 21, 21),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.thumb_up_alt,
                              size: 64.0,
                              color: Colors.pink.shade300,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Feedback",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
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
    );
  }
}
