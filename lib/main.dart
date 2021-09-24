

import 'package:chat_app_ui_b/pages/audio_call_with_image.dart';
import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:chat_app_ui_b/pages/dial_screen.dart';
import 'package:chat_app_ui_b/pages/group_call.dart';
import 'package:chat_app_ui_b/pages/home_page.dart';
import 'package:chat_app_ui_b/pages/login_page.dart';
import 'package:chat_app_ui_b/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LocalStorage storage = new LocalStorage('todo_app');
Color backgroundColor = Colors.white;
Color textColor = Colors.black;
final String host_port = "http://25.30.10.3:8080";
String currentTokenJWT = "";
String currentUserID = "";
String currentDisplayName = "";
String currentUsername = "";
String currentEmail = "";
String currentNameAvatar = "";
final socketUrl = host_port + '/backend' + '/ws-message';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void initializeNotification() async {
  try {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  } catch(e) {
    print(e.toString());
  }
}

//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;



void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  // var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  // var iOS = new IOSInitializationSettings();
  // var initSetttings = new InitializationSettings(android: android, iOS: iOS);
  // flutterLocalNotificationsPlugin.initialize(initSetttings,
  //     onSelectNotification: onSelectNotification);

  runApp(MyApp());
  initializeNotification();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentInformation();
  }

  getCurrentInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentTokenJWT = prefs.getString("currentTokenJWT");
    currentUserID = prefs.getString("currentUserID");
    currentDisplayName = prefs.getString("currentDisplayName");
    currentUsername = prefs.getString("currentUsername");
    currentEmail = prefs.getString("currentEmail");
    currentNameAvatar = prefs.getString("currentNameAvatar");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      //home: SplashScreen(),
      home: GroupCallScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      //home: WebViewPage(),
      home: currentTokenJWT != null && currentTokenJWT.contains(".") ? HomePage() : LoginPage(),
    );
  }
}

// add main