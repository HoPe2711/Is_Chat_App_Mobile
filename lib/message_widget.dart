import 'dart:convert';

import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:chat_app_ui_b/pages/display_search_message.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MessageWidget extends StatefulWidget {
  String senderName;
  String content;
  String timestamp;
  String id;
  List<PerEmo> listEmotions;
  MessageWidget({Key key, this.senderName, this.content, this.timestamp, this.id, this.listEmotions}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  List<PerEmo> currentEmo = [];
  int vt = 0;
  bool pressHeart = false, pressLaugh = false, pressCry = false, pressAngry = false;
  String imageNetWorkHeart = "https://image.flaticon.com/icons/png/512/3237/3237429.png";
  String imageNetWorkLaugh = "https://image.flaticon.com/icons/png/512/742/742920.png";
  String imageNetWorkCry = "https://image.flaticon.com/icons/png/512/1933/1933788.png";
  String imageNetWorkAngry = "https://image.flaticon.com/icons/png/512/743/743419.png";
  bool visibilityInf = false;
  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "inf"){
        visibilityInf = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.listEmotions == null ?
        Container(child: Center(child: CircularProgressIndicator()))
            : Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              currentDisplayName == widget.senderName ?
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.listEmotions.length == 0 || widget.listEmotions == null ?
                  Container() : GestureDetector(
                    onTap: (){
                      print(widget.listEmotions.length);
                      showAlertDialog(context);
                    },
                    child: Container(
                      child: Image.network("https://cdn-icons-png.flaticon.com/128/3062/3062575.png"),
                      height: 50, width: 50,
                    ),
                  ),

                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      visibilityInf ? Text(
                        "${widget.senderName}",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontFamily: "GoblinOne",
                          fontSize: 15,
                        ),
                      ) : Container(),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.content == "This message has been deleted!" ?
                          Colors.grey : Colors.pink[100],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              blurRadius: 9,
                              spreadRadius: 5,
                              offset: Offset(3, 6),
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft:
                            Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: Container(
                          child: TextButton(
                            onLongPress: (){
                              showAlertDialog(context);
                            },
                            onPressed: (){
                              print("${widget.id}--${widget.senderName}--${widget.content}--${widget.timestamp}--$currentUserID--$currentDisplayName");
                              if(visibilityInf == false){
                                _changed(true, "inf");
                              } else {
                                _changed(false, "inf");
                              }
                            },
                            child: Text(
                              "${widget.content}",
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                                fontFamily:
                                "Times New Roman",
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      visibilityInf ? Column(
                        children: [
                          Text(
                            "${widget.timestamp}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: (){
                                  print("${widget.id} -- $currentUserID");
                                  sendDelete(widget.id, currentUserID);
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkHeart),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "heart");
                                  setState(()  {
                                    pressHeart = true;
                                    pressLaugh = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkLaugh),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "laugh");
                                  setState(() {
                                    pressLaugh = true;
                                    pressHeart = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkCry),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "cry");
                                  setState(() {
                                    pressCry = true;
                                    pressLaugh = pressHeart = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkAngry),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "angry");
                                  setState(() {
                                    pressAngry = true;
                                    pressLaugh = pressCry = pressHeart = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ) : Container(),
                    ],
                  ),
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor:
                    Colors.orangeAccent,
                    child: Text(
                      "${widget.senderName.characters.first.toUpperCase()}",
                      style: TextStyle(
                        color: Colors.white,
                        //fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "GoblinOne",
                      ),
                    ),
                    radius: 20,
                  ),
                ],
              ) :
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Text(
                      "${widget.senderName.characters.first.toUpperCase()}",
                      style: TextStyle(
                        color: Colors.white,
                        //fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "GoblinOne",
                      ),
                    ),
                    radius: 20,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      visibilityInf ? Text(
                        "${widget.senderName}",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontFamily: "GoblinOne",
                          fontSize: 15,
                        ),
                      ) : Container(),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.content == "This message has been deleted!" ?
                          Colors.grey : Colors.grey[300],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              blurRadius: 9,
                              spreadRadius: 5,
                              offset: Offset(3, 6),
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        child: Container(
                          child: TextButton(
                            onPressed: (){
                              if(visibilityInf == false){
                                _changed(true, "inf");
                              } else {
                                _changed(false, "inf");
                              }
                            },
                            child: Text(
                              "${widget.content}",
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                                fontFamily: "Times New Roman",
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      visibilityInf ? Column(
                        children: [
                          Text(
                            "${widget.timestamp}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Image.network(imageNetWorkHeart),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "heart");
                                  setState(() {
                                    pressHeart = true;
                                    pressLaugh = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkLaugh),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "laugh");
                                   setState(() {
                                    pressLaugh = true;
                                    pressHeart = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkCry),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "cry");
                                  setState(() {
                                    pressCry = true;
                                    pressLaugh = pressHeart = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkAngry),
                                onPressed: () async {
                                  await sendEmotion(widget.id, "angry");
                                  setState(() {
                                    pressAngry = true;
                                    pressLaugh = pressCry = pressHeart = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: (){
                                  print("${widget.id} -- $currentUserID");
                                  sendDelete(widget.id, currentUserID);
                                },
                              ),
                            ],
                          ),
                        ],
                      ) : Container(),
                    ],
                  ),
                  widget.listEmotions.length == 0 || widget.listEmotions == null ?
                  Container() : GestureDetector(
                    onTap: (){
                      for(int i=0; i < list.messages.length; i++){
                        if(widget.id == list.messages[i].id){
                          vt = i;
                          break;
                        }
                      }
                      print(vt);
                      showAlertDialog(context);
                    },
                    child: Container(
                      child: Image.network("https://cdn-icons-png.flaticon.com/128/3062/3062575.png"),
                      height: 50, width: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  sendEmotion(String chatId, String emo) async {
    if (emo != "") {
      stompClient.send(
        destination: "/app/react",
        body: jsonEncode(<String, String>{
          "chatId": chatId,
          "senderId": currentUserID,
          "senderName": currentDisplayName,
          "emotion": emo,
        }),
      );
      print("send");
    }
  }

  sendDelete(String chatId, String senderId) async {
    stompClient.send(
      destination: "/app/delete_message",
      body: jsonEncode(<String, String>{
        "chatId": chatId,
        "senderId": currentUserID,
      }),
    );
    print("delete");
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text(""),
      onPressed: (){

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Emotions"),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height*0.4,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.listEmotions.length,
                  itemBuilder: (context, index){
                    return ListTile(
                        leading: Image.network(
                            widget.listEmotions[index].emotion == 'heart' ?
                            "https://image.flaticon.com/icons/png/512/3237/3237429.png" :
                            widget.listEmotions[index].emotion == 'laugh' ?
                            "https://image.flaticon.com/icons/png/512/742/742920.png" :
                            widget.listEmotions[index].emotion == 'cry' ?
                            "https://image.flaticon.com/icons/png/512/1933/1933788.png" :
                            "https://image.flaticon.com/icons/png/512/743/743419.png"
                        ),
                      //list.messages[vt].listEmotions.last.emotion == 'heart' ? Text(list.messages[vt].listEmotions.last.emotion.toString()),
                        title: Text(widget.listEmotions[index].senderName.toString()),
                      );
                  }
              ),
            ),
            Divider(),
          ],
        ),
      ),
      actions: [
        cancelButton,
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
