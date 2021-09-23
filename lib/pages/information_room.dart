import 'package:chat_app_ui_b/conversation_list.dart';
import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/models/search_chat_massage.dart';
import 'package:chat_app_ui_b/pages/display_search_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class InformationRoom extends StatefulWidget {
  String roomImageUrl;
  String roomId;
  String roomName;
  InformationRoom({Key key, this.roomImageUrl, this.roomId, this.roomName}) : super(key: key);

  @override
  _InformationRoomState createState() => _InformationRoomState();
}

class _InformationRoomState extends State<InformationRoom> {
  TextEditingController _searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.scatter_plot,
              color: Colors.black,
            ),
            onPressed: (){
              print("develop");
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          CircleAvatar(
            radius: 60,
            child: Image.network("${widget.roomImageUrl}"),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              widget.roomName,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: Offset(3,6),
                  )
                ]
              ),
            ),
          ),
          ListTile(
            title: Text("Search in chat room"),
            trailing: IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showAlertDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed:  () {
          _searchTextController.clear();
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
    );
    Widget searchButton = TextButton(
      child: Text("Search"),
      onPressed: (){
        _searchTextController.text == "" ? Fluttertoast.showToast(
            msg: "Please fill message content !",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0)
        : Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.push(context, MaterialPageRoute(builder: (context) => DisplaySearchMessage(roomName: widget.roomName, roomId: widget.roomId, textSearch: _searchTextController.text, roomImageUrl: widget.roomImageUrl,))).then((value) => _searchTextController.clear());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Search in room chat"),
      content: TextField(
        controller: _searchTextController,
      ),
      actions: [
        cancelButton,
        searchButton,
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
