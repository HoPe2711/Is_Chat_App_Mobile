import 'dart:convert';

import 'package:chat_app_ui_b/conversation_list.dart';
import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/models/all_room_model.dart';
import 'package:chat_app_ui_b/models/search_room_model.dart';
import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;





class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}



Future<AllRoom> getAllRoom() async {
  final String apiUrl = host_port + "/backend/auth/user_room";

  final response = await http.get(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
  );

  if (response.statusCode == 200)  {
    final String responseString = response.body;
    return allRoomFromJson(responseString);
  } else {
    return null;
  }
}

Future<SearchRoom> getSearchRoom(String word, int touch) async {
  final String apiUrl = host_port + "/backend/auth/find_room/$word/$touch";

  final response = await http.get(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
  );

  if (response.statusCode == 200)  {
    final String responseString = response.body;
    return searchRoomFromJson(responseString);
  } else {
    return null;
  }
}



createNewRoom(String roomName) async {

  final String apiUrl = host_port + "/backend/auth/room";

  final response = await http.post(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
    body: jsonEncode(<String, String>{
      "roomName": roomName,
    }),
  );
  if (response.statusCode == 200){
    final Map<String, dynamic> responseMap = json.decode(response.body);
    return responseMap['data'];
  } else {
    return null;
  }
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameRoomController = TextEditingController();
  AllRoom _allRoom;
  SearchRoom _searchRoom;

  bool _running = true;
  Stream<String> _clock() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(Duration(milliseconds: 300));
      DateTime _now = DateTime.now();
      AllRoom allRoom = await getAllRoom();
      setState(() {
        _allRoom = allRoom;
      });
      // This will be displayed on the screen as current time
      //yield "${_now.hour} : ${_now.minute} : ${_now.second}";
      yield _allRoom.data.first.content;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAllRoom();
  }
  setAllRoom() async {
    final AllRoom allRoom = await getAllRoom();
    if(allRoom == null) {
      setState(() {
        _allRoom = storage.getItem("allRoom");
      });
    } else {
      setState(() {
        _allRoom = allRoom;
        storage.setItem("allRoom", _allRoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    GestureDetector(
                      onTap: (){
                        showAlertDialog(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add,color: Colors.pink,size: 20,),
                            SizedBox(width: 2,),
                            Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (text) async {
                  print(text);
                  SearchRoom searchRoom = await getSearchRoom(text, 0);
                  setState(() {
                    _searchRoom = searchRoom;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            _allRoom == null ? SafeArea(child: Center(child: CircularProgressIndicator()))
            : _searchRoom == null ?
            StreamBuilder(
              stream: _clock(),
              builder: (context, snapshot) {
                return ListView.builder(
                  //itemCount: chatUsers.length,
                  itemCount: _allRoom.data.length,
                  //reverse: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return ConversationList(
                      roomID: _allRoom.data[index].id,
                      roomName: _allRoom.data[index].roomName,
                      messageText: _allRoom.data[index].content == null ? "No message in hear !"
                          : "${_allRoom.data[index].senderName}: ${_allRoom.data[index].content}",
                      roomImageUrl: "https://i1.wp.com/roohentertainment.com/wp-content/uploads/2018/06/user-avatar-1.png?ssl=1",
                      time: _allRoom.data[index].timestamp == null ? ""
                          : dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(_allRoom.data[index].timestamp)).toString(),
                      isMessageRead: true,
                    );
                  },
                );
              }
            ) : ListView.builder(
                  //itemCount: chatUsers.length,
                  itemCount: _searchRoom.data.length,
                  //reverse: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return ConversationList(
                      roomID: _searchRoom.data[index].id,
                      roomName: _searchRoom.data[index].roomName,
                      messageText: _searchRoom.data[index].content == null ? "No message in hear !"
                          : "${_searchRoom.data[index].senderName}: ${_searchRoom.data[index].content}",
                      roomImageUrl: "https://i1.wp.com/roohentertainment.com/wp-content/uploads/2018/06/user-avatar-1.png?ssl=1",
                      time: _searchRoom.data[index].timestamp == null ? ""
                          : dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(_searchRoom.data[index].timestamp)).toString(),
                      isMessageRead: true,
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        if(_nameRoomController.text == ""){
          Fluttertoast.showToast(
              msg: "Please fill Room Name",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          final String roomName = _nameRoomController.text;
          final String createNewRoomResponse = await createNewRoom(roomName);
          Fluttertoast.showToast(
              msg: createNewRoomResponse,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pop();
          final AllRoom allRoom = await getAllRoom();
          setState(() {
            _allRoom = allRoom;
          });
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Create New Room"),
      content: TextField(
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        controller: _nameRoomController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: "Room Name",
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
}