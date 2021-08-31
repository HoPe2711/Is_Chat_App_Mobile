import 'dart:convert';

import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/models/each_room_model.dart';
import 'package:chat_app_ui_b/pages/add_member_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemberPage extends StatefulWidget {
  String roomID;
  MemberPage({Key key, this.roomID}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
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

class _MemberPageState extends State<MemberPage> {
  TextEditingController _searchController = TextEditingController();
  EachRoom _eachRoom;

  Future<EachRoom> getInformationRoom() async {

    final String apiUrl = host_port + "/backend/auth/room/${widget.roomID}";

    final response = await http.get(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentTokenJWT',
      },
    );

    if (response.statusCode == 200){
      final String responseString = response.body;
      return eachRoomFromJson(responseString);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInforRoom();
  }
  getInforRoom() async {
    final EachRoom eachRoom = await getInformationRoom();
    setState(() {
      _eachRoom = eachRoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.people),
                  text: "All",
                ),
                Tab(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  text: "Administrators",
                ),
              ],
            ),
            title: Text('Member'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemberPage(roomId: widget.roomID)));
                },
              ),
            ],
          ),
          body: _eachRoom == null ? Center(child: CircularProgressIndicator()) :
          TabBarView(
            children: [
              ListView.builder(
                itemCount: _eachRoom.data.userList.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(
                      //backgroundImage: NetworkImage(widget.imageUrl),
                      child: Text(_eachRoom.data.userList[index].displayName.characters.first.toUpperCase()),
                      maxRadius: 30,
                    ),
                    title: Text(_eachRoom.data.userList[index].displayName),
                    subtitle: Text("Member"),
                  );
                },
              ),
              ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(
                      //backgroundImage: NetworkImage(widget.imageUrl),
                      child: Text(_eachRoom.data.host.displayName.characters.first.toUpperCase()),
                      maxRadius: 30,
                    ),
                    title: Text(_eachRoom.data.host.displayName),
                    subtitle: Text("Administrator"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
