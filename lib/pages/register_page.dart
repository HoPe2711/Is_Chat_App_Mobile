import 'dart:convert';

import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

registerUser(String username, String password,
    String retypePassword, String displayName, String email) async {
  final String apiUrl = host_port + "/backend/auth/sign-up";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "username": username,
      "password": password,
      "retypePassword": retypePassword,
      "displayName": displayName,
      "email": email,
    }),
  );
  if (response.statusCode == 400) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  }
  if (response.statusCode == 200){
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['data'];
  } else {
    return null;
  }
}

verifyEmail(String token) async {
  final String apiUrl = host_port + "/backend/auth/verify";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "token": token,
    }),
  );
  if (response.statusCode == 403) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  }
  if (response.statusCode == 200){
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  } else {
    return null;
  }
}


class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _displayNameController = new TextEditingController();
  TextEditingController _retypePasswordController = new TextEditingController();
  TextEditingController _verifyCodeController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                color: backgroundColor
                ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Register now !',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "GoblinOne",
                    ),
                  ),
                  Text(
                    'Login to continue using iMess',
                    style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontFamily: "GoblinOne"),
                  ),
                  SizedBox(height: 50),
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
                      labelText: 'Username',
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
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: 'Display name',
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                      prefixIcon: Container(
                        width: 50,
                        child: Icon(
                          Icons.account_circle_rounded,
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                      prefixIcon: Container(
                        width: 50,
                        child: Icon(
                          Icons.email,
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
                          Icons.lock,
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
                    controller: _retypePasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Confirm Password",
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
                  SizedBox(height: 30),
                  Container(
                    width: 300.00,
                    child: RaisedButton(
                        onPressed: () async{
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
                              if (_retypePasswordController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "Please fill retype password !",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                if (_emailController.text == "") {
                                  Fluttertoast.showToast(
                                      msg: "Please fill email!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  if (_displayNameController.text == "") {
                                    Fluttertoast.showToast(
                                        msg: "Please fill display name!",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    final String username = _usernameController.text;
                                    final String password = _passController.text;
                                    final String retypePassword = _retypePasswordController.text;
                                    final String displayName = _displayNameController.text;
                                    final String email = _emailController.text;

                                    final String register = await registerUser(username, password, retypePassword, displayName, email);
                                    Fluttertoast.showToast(
                                        msg: "$register",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    if(register.contains("Waiting for verification")){
                                      showAlertDialog(context);
                                    }
                                  }
                                }
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
                            constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 30),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 3,
                  //       child: Text(
                  //         "Signup with",
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
                  //         onTap: () {
                  //           Fluttertoast.showToast(
                  //               msg:
                  //                   "This feature is currently in development !",
                  //               toastLength: Toast.LENGTH_LONG,
                  //               gravity: ToastGravity.CENTER,
                  //               timeInSecForIosWeb: 1,
                  //               backgroundColor: Colors.red,
                  //               textColor: Colors.white,
                  //               fontSize: 16.0);
                  //         },
                  //         splashColor: Colors.black,
                  //         child: CircleAvatar(
                  //           backgroundImage:
                  //               AssetImage("assets/logo_gmail2.jpg"),
                  //           radius: 30,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: InkWell(
                  //         onTap: () {
                  //           Fluttertoast.showToast(
                  //               msg:
                  //                   "This feature is currently in development !",
                  //               toastLength: Toast.LENGTH_LONG,
                  //               gravity: ToastGravity.CENTER,
                  //               timeInSecForIosWeb: 1,
                  //               backgroundColor: Colors.red,
                  //               textColor: Colors.white,
                  //               fontSize: 16.0);
                  //         },
                  //         splashColor: Colors.black,
                  //         child: CircleAvatar(
                  //           backgroundImage: AssetImage("assets/logo_fb.jpg"),
                  //           radius: 30,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Already have an Account? ',
                          style: TextStyle(
                            //fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "GoblinOne",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text(
                            'Login now',
                            style: TextStyle(
                              fontFamily: "GoblinOne",
                              //fontSize: 12,
                              color: textColor,
                            ),
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
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Verify"),
      onPressed: () async {
        final String token = _verifyCodeController.text;
        final String verifyResponse = await verifyEmail(token);
        if(verifyResponse.contains("Request successfully")){
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          //Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg:
              "Wrong verify code !",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Verify Email"),
      content: TextField(
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        controller: _verifyCodeController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: "Verify Code",
          labelStyle: TextStyle(
            color: textColor,
          ),
          prefixIcon: Container(
            width: 50,
            child: Icon(
              Icons.verified_user_rounded,
              color: textColor,
            ),
          ),
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

