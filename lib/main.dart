import 'dart:convert';

import 'package:eguru_v2/config.dart';
import 'package:eguru_v2/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//Run application here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('e_guru_icon');

  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});

  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'E-Guru',
        theme: ThemeData(fontFamily: 'Raleway'),
        home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
    initOneSignal();
  }

  Future checkIfAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  Future<String> _authUser(LoginData data, BuildContext context) async {
    var baseUrl = Uri.parse("$API_URL/login");

    print('Email: ${data.name},  Password: ${data.password}');

    try {
      var response = await http.post(
        baseUrl,
        body: {'email': data.name, 'password': data.password},
        headers: {'Accept': 'application/json'},
      );

      var jsonResponse = json.decode(response.body);
      var userId = jsonResponse["user_id"];
      var token = jsonResponse["token"];
      var firstName = jsonResponse["user_firstname"];
      var lastName = jsonResponse["user_lastname"];
      var avatar = jsonResponse["user_avatar"];
      var email = jsonResponse["user_email"];

      if (jsonResponse['errors'] != null) {
        // kalau login fail
        return jsonResponse['message'];
      } else if (jsonResponse['message'] == 'Success') {
        // kalau login success

        // Simpan dalam phone local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('userId', userId);
        prefs.setString('token', token);
        prefs.setString('firstName', firstName);
        prefs.setString('lastName', lastName);
        prefs.setString('avatar', avatar);
        prefs.setString('email', email);

        // Navigate ke page lain
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        return null;
      } else {
        return 'Server error';
      }
    } catch (e) {
      // kalau tak boleh connect ke server
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'E-Guru Application',
      logo: 'assets/images/e-guru-icon.png',
      messages: LoginMessages(loginButton: 'Login'),
      theme: LoginTheme(
        primaryColor: Colors.blue.shade700,
        accentColor: Colors.white,
        titleStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      onLogin: (LoginData loginData) {
        return _authUser(loginData, context);
      },
      onSignup: null,
      hideSignUpButton: true,
      onSubmitAnimationCompleted: () {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => DashboardScreen(),
        // ));
      },
      onRecoverPassword: null,
      hideForgotPasswordButton: true,
    );
  }

  void initOneSignal() {
    OneSignal.shared.init('4df855c4-7e77-4558-8083-658361606d31');

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }
}
