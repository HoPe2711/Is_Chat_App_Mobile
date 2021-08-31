
import 'dart:convert';

import 'package:chat_app_ui_b/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class TitleAddUserWidget extends StatefulWidget{
  String userImageUrl;
  String displayName;
  String username;
  String email;

  String roomId;
  String userId;
  TitleAddUserWidget({@required this.userImageUrl,@required this.displayName,@required this.username,@required this.email,@required this.roomId,@required this.userId});

  @override
  _TitleAddUserWidgetState createState() => _TitleAddUserWidgetState();
}

addMemberToGroup(String roomId, String userId) async {
  final String apiUrl = host_port + "/backend/auth/user_room/$userId/$roomId";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
  );

  if (response.statusCode == 200)  {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['data'];
  }
  if (response.statusCode == 400)  {
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['status']['message'];
  } else {
    return null;
  }
}

class _TitleAddUserWidgetState extends State<TitleAddUserWidget> {
  String _add = "Add";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImageUrl),
                  maxRadius: 30,
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.displayName, style: TextStyle(fontSize: 16),),
                        SizedBox(height: 6,),
                        Text(widget.email,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.bold ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              String response = await addMemberToGroup(widget.roomId, widget.userId);
              Fluttertoast.showToast(
                  msg: "$response !",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              setState(() {
                _add = "Added";
              });
            },
            child: Text(_add),
          ),
        ],
      ),
    );
  }
}