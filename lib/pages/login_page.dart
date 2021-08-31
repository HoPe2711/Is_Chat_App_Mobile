import 'dart:convert';

import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:chat_app_ui_b/pages/forgot_password_page.dart';
import 'package:chat_app_ui_b/pages/home_page.dart';
import 'package:chat_app_ui_b/pages/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
// var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
// var iOS = new IOSInitializationSettings();
// var initSetttings = new InitializationSettings(android: android, iOS: iOS);
// await flutterLocalNotificationsPlugin.initialize(initializationSettings,
// onSelectNotification: onSelectNotification);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

login(String username, String password) async {
  final String apiUrl = host_port + "/backend/auth/login";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "username": username,
      "password": password,
    }),
  );
  if (response.statusCode == 403) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  }
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUserID", responseMap['data']['id']);
    prefs.setString("currentDisplayName", responseMap['data']['displayName']);
    prefs.setString("currentUsername", responseMap['data']['username']);
    prefs.setString("currentEmail", responseMap['data']['email']);
    return responseMap['data']['token'];
  } else {
    return null;
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(msg: "---$currentTokenJWT---");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Welcome back !',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "GoblinOne",
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Login to continue using iMess',
                      style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontFamily: "GoblinOne"),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                      prefixIcon: Container(
                        width: 50,
                        child: Icon(
                          Icons.person,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    obscureText: true,
                    controller: _passController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                      prefixIcon: Container(
                        width: 50,
                        child: Icon(
                          Icons.lock_outline,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                            fontFamily: "GoblinOne",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 300.00,
                    child: RaisedButton(
                        onPressed: () async {
                          if (_usernameController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please fill username !",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            if (_passController.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Please fill password !",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              final String username = _usernameController.text;
                              final String password = _passController.text;
                              String loginResponse =
                                  await login(username, password);
                              if (loginResponse.contains(".")) {
                                currentTokenJWT = loginResponse;
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("currentTokenJWT", currentTokenJWT);

                                // flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
                                // var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
                                // var iOS = new IOSInitializationSettings();
                                // var initSetttings = new InitializationSettings(android: android, iOS: iOS);
                                // await flutterLocalNotificationsPlugin.initialize(initSetttings,
                                //     onSelectNotification: onSelectNotification);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "$loginResponse",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        elevation: 0.0,
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Colors.redAccent, Colors.pinkAccent]),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 50),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 3,
                  //       child: Text(
                  //         "Login with",
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           fontFamily: "GoblinOne",
                  //           fontSize: 20,
                  //           color: textColor,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: InkWell(
                  //         onTap: () {},
                  //         splashColor: Colors.black,
                  //         child: CircleAvatar(
                  //           backgroundImage:
                  //               AssetImage("assets/logo_instagram2.jpg"),
                  //           radius: 30,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: InkWell(
                  //         onTap: () {},
                  //         splashColor: Colors.black,
                  //         child: CircleAvatar(
                  //           backgroundImage: AssetImage("assets/logo_fb.jpg"),
                  //           radius: 30,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text(
                          'New user? ',
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontSize: 10,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "GoblinOne",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Text(
                            'Sign up for a new account',
                            style: TextStyle(
                                fontFamily: "GoblinOne",
                                //fontSize: 13,
                                color: textColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
