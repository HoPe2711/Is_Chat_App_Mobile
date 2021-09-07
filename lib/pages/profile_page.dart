import 'dart:convert';
import 'dart:io';

import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:chat_app_ui_b/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

changePassword(
    String oldPassword, String newPassword, String retypePassword) async {
  final String apiUrl = host_port + "/backend/auth/changepassword";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
    body: jsonEncode(<String, String>{
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "retypePassword": retypePassword,
    }),
  );
  if (response.statusCode == 400) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  }
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['data'];
  } else {
    return null;
  }
}

changeDisplayName(String displayName) async {
  final String apiUrl = host_port + "/backend/auth/profile";

  final response = await http.put(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
    body: jsonEncode(<String, String>{
      "displayName": displayName,
    }),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  } else {
    return null;
  }
}

changeAvatar(String filepath, String url) async {
  var request = http.MultipartRequest('PUT', Uri.parse(url));
  request.files.add(http.MultipartFile('image',
      File(filepath).readAsBytes().asStream(), File(filepath).lengthSync(),
      filename: filepath.split("/").last));
  request.fields.addAll({"displayName": "$currentUsername"});
  request.headers.addAll({
    'Content-Type': 'application/json; charset=UTF-8; multipart/form-data',
    'Authorization': 'Bearer $currentTokenJWT',
  });
  var res = await request.send();
  if (res.statusCode == 200) {
    final responseString = await res.stream.bytesToString();
    final Map<String, dynamic> responseMap = json.decode(responseString);
    return responseMap['data']['avatar'];
  }
  return res.statusCode;
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _editingController = TextEditingController();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _retypePasswordController = TextEditingController();

  File _image;
  String _imagePath;

  _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    setState(() {
      _imagePath = _image.path;
      print("_imagePath: ....$_imagePath");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfor();
  }

  getInfor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentDisplayName = prefs.getString("currentDisplayName");
      currentUsername = prefs.getString("currentUsername");
      currentEmail = prefs.getString("currentEmail");
      currentNameAvatar = prefs.getString("currentNameAvatar");
    });
    print(currentNameAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.redAccent, Colors.pinkAccent])),
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _image == null
                              ? CircleAvatar(
                                  backgroundImage: currentNameAvatar == "" ||
                                          currentNameAvatar == null
                                      ? NetworkImage(
                                          'https://vnn-imgs-f.vgcloud.vn/2020/03/23/11/trend-avatar-11.jpg')
                                      : NetworkImage(
                                          '$host_port/backend/images/$currentNameAvatar',
                                          headers: {
                                              'Content-Type':
                                                  'application/json; charset=UTF-8',
                                              'Authorization':
                                                  'Bearer $currentTokenJWT',
                                            }),
                                  radius: 50.0,
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.black.withOpacity(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      _image,
                                      cacheWidth: 100,
                                      cacheHeight: 100,
                                      //fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  radius: 50,
                                ),
                          Container(
                            height: 25,
                            width: 25,
                            child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                              tooltip: "Change Avatar",
                              onPressed: () async {
                                await _getImage();
                                print(_image);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.save_alt),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs
                                .setString(
                                    "currentNameAvatar",
                                    await changeAvatar(_imagePath,
                                        "$host_port/backend/auth/profile"))
                                .then((value) => Fluttertoast.showToast(
                                    msg: "Save Image Done !",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0));
                            setState(() {
                              currentNameAvatar = prefs.getString("currentNameAvatar");
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$currentDisplayName",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            tooltip: "Change Display Name",
                            onPressed: () {
                              showAlertDialog(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Friends",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "5200",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "28.5K",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "News",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "1300",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Account Information:",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontStyle: FontStyle.normal,
                        fontSize: 28.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Name - $currentDisplayName\n'
                    'Username - $currentUsername\n'
                    'Email - $currentEmail\n',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 300.00,
            child: RaisedButton(
                onPressed: () async {
                  showAlertDialog2(context);
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
                      "Change Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
          ),
          SizedBox(height: 20.0),
          Container(
            width: 300.00,
            child: RaisedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("currentTokenJWT", "");
                  currentTokenJWT = "";
                  prefs.clear();
                  storage.clear();
                  stompClient.deactivate();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
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
                      "Log out",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Change"),
      onPressed: () async {
        if (_editingController.text == "") {
          Fluttertoast.showToast(
              msg: "Please fill Display Name",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          final String displayName = _editingController.text;
          final String changeDisplayNameResponse =
              await changeDisplayName(displayName);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("currentDisplayName", _editingController.text);

          Fluttertoast.showToast(
              msg: "$changeDisplayNameResponse",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pop();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Display Name"),
      content: TextField(
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        controller: _editingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: "Display Name",
          labelStyle: TextStyle(
            color: textColor,
          ),
          prefixIcon: Container(
            width: 50,
            child: Icon(
              Icons.edit,
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

  showAlertDialog2(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text("Change"),
        onPressed: () async {
          if (_oldPasswordController.text == "") {
            Fluttertoast.showToast(
                msg: "Please fill old password",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            if (_newPasswordController.text == "") {
              Fluttertoast.showToast(
                  msg: "Please fill new password",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              if (_retypePasswordController.text == "") {
                Fluttertoast.showToast(
                    msg: "Please fill retype password",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                final String oldPassword = _oldPasswordController.text;
                final String newPassword = _newPasswordController.text;
                final String retypePassword = _retypePasswordController.text;

                final String changeResponse = await changePassword(
                    oldPassword, newPassword, retypePassword);
                Fluttertoast.showToast(
                    msg: "$changeResponse",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                if (changeResponse.contains("Password has changed !")) {
                  Navigator.of(context).pop();
                }
              }
            }
          }
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Password"),
      content: Column(
        children: [
          TextField(
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            controller: _oldPasswordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              labelText: "Old Password",
              labelStyle: TextStyle(
                color: textColor,
              ),
              prefixIcon: Container(
                width: 50,
                child: Icon(
                  Icons.edit,
                  color: textColor,
                ),
              ),
            ),
          ),
          TextField(
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            controller: _newPasswordController,
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
                  Icons.edit,
                  color: textColor,
                ),
              ),
            ),
          ),
          TextField(
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            controller: _retypePasswordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              labelText: "Old Password",
              labelStyle: TextStyle(
                color: textColor,
              ),
              prefixIcon: Container(
                width: 50,
                child: Icon(
                  Icons.edit,
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
