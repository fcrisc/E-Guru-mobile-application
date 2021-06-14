import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eguru_v2/main.dart';
import 'package:eguru_v2/home.dart';
import 'package:eguru_v2/classroom.dart';
import 'package:eguru_v2/profile.dart';
import 'package:eguru_v2/timetable.dart';
import 'package:eguru_v2/complaint_display.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eguru_v2/config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ComplaintForm extends StatefulWidget {
  ComplaintForm({Key key}) : super(key: key);

  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  String complaint_type, complaint_description;

  var userId = '';

  var firstName = '';
  var lastName = '';
  var avatar = '';
  var token = '';

  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      postComplaint();
    }
  }

  @override
  initState() {
    super.initState();
    getPref();
  }

  Future getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId').toString();
      token = prefs.getString('token');
      firstName = prefs.getString('firstName');
      lastName = prefs.getString('lastName');
      avatar = prefs.getString('avatar');
    });
  }

  void postComplaint() async {
    var response =
        await http.post(Uri.parse("$API_URL/postcomplaint"), headers: {
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    }, body: {
      "user_id": userId,
      "complaint_type": '$complaint_type',
      "complaint_description": '$complaint_description',
    });

    final data = jsonDecode(response.body);
    String message = data['message'];
    registerToast(message);
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          // backgroundColor: Color(0xFF2D2F41),
          title: Text('Complaint Form'),
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
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Hello !',
                          style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Arial"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Make complaint or give feedback",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        //card for Fullname TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            // ignore: missing_return
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert feedback type";
                              }
                            },
                            onSaved: (e) => complaint_type = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.title, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Feedback Type"),
                          ),
                        ),
                        //card for Email TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            maxLines: 8,
                            // ignore: missing_return
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert description";
                              }
                            },
                            onSaved: (e) => complaint_description = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child:
                                      Icon(Icons.message, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Description"),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(12.0),
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 56.0,
                              width: 346.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0)),
                                  child: Text(
                                    "Submit Feedback",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  textColor: Colors.white,
                                  color: Colors.blue.shade700,
                                  onPressed: () {
                                    check();
                                  }),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        ));
  }
}
