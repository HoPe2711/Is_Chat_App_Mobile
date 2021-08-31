import 'dart:convert';

import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

forgot(String username, String email) async {
  final String apiUrl = host_port + "/backend/auth/forgot";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "username": username,
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

reset(String password, String retypePassword, String token) async {
  final String apiUrl = host_port + "/backend/auth/reset";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "password": password,
      "retypePassword": retypePassword,
      "token": token,
    }),
  );
  if (response.statusCode == 403) {
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

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  TextEditingController _verifyCodeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _retypePasswordController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              //color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Forgot password !',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "GoblinOne",
                      ),
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
                  SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.green[800],
                              Colors.green[600],
                              Colors.green[400],
                              Colors.green[200],
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    height: 40,
                    width: 150,
                    //width: double.infinity,
                    child: RaisedButton(
                        onPressed: () async {
                          if(_usernameController.text == ""){
                            Fluttertoast.showToast(
                                msg: "Please fill username !",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else {
                            if(_emailController.text == ""){
                              Fluttertoast.showToast(
                                  msg: "Please fill email !",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                            else {
                              final String username = _usernameController.text;
                              final String email = _emailController.text;

                              final String forgotResponse = await forgot(username, email);
                              Fluttertoast.showToast(
                                  msg: "$forgotResponse",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              if(forgotResponse.contains("A reset token has been sent to")){
                                showAlertDialog(context);
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
                              "FORGOT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 50),
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
      child: Text("Reset Password"),
      onPressed: () async {

        final String password = _passwordController.text;
        final String retypePassword = _retypePasswordController.text;
        final String token = _verifyCodeController.text;

        final String resetResponse = await reset(password, retypePassword, token);
        if(resetResponse.contains("Password has changed !")){
          Fluttertoast.showToast(
              msg:
              "$resetResponse",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          //Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg:
              "$resetResponse",
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
      title: Text("Reset Password"),
      content: Column(
        children: [
          TextField(
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              labelText: "New Password",
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
              labelText: "Retype new password",
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
        ],
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
