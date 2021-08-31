import 'package:flutter/material.dart';

import 'main.dart';

class MessageWidget extends StatefulWidget {
  String senderName;
  String content;
  String timestamp;
  MessageWidget({Key key, this.senderName, this.content, this.timestamp}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
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
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              currentDisplayName == widget.senderName ?
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  pressHeart ? Container(
                    child: Image.network(imageNetWorkHeart),
                    height: 50, width: 50,
                  ) : Container(),
                  pressLaugh ? Container(
                    child: Image.network(imageNetWorkLaugh),
                    height: 50, width: 50,
                  ) : Container(),
                  pressCry ? Container(
                    child: Image.network(imageNetWorkCry),
                    height: 50, width: 50,
                  ) : Container(),
                  pressAngry ? Container(
                    child: Image.network(imageNetWorkAngry),
                    height: 50, width: 50,
                  ) : Container(),

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
                          color: Colors.pink[100],
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
                                icon: Image.network(imageNetWorkHeart),
                                onPressed: (){
                                  setState(() {
                                    pressHeart = true;
                                    pressLaugh = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkLaugh),
                                onPressed: (){
                                  setState(() {
                                    pressLaugh = true;
                                    pressHeart = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkCry),
                                onPressed: (){
                                  setState(() {
                                    pressCry = true;
                                    pressLaugh = pressHeart = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkAngry),
                                onPressed: (){
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
                          color: Colors.grey[300],
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
                                onPressed: (){
                                  setState(() {
                                    pressHeart = true;
                                    pressLaugh = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkLaugh),
                                onPressed: (){
                                  setState(() {
                                    pressLaugh = true;
                                    pressHeart = pressCry = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkCry),
                                onPressed: (){
                                  setState(() {
                                    pressCry = true;
                                    pressLaugh = pressHeart = pressAngry = false;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Image.network(imageNetWorkAngry),
                                onPressed: (){
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
                  pressHeart ? Container(
                    child: Image.network(imageNetWorkHeart),
                    height: 50, width: 50,
                  ) : Container(),
                  pressLaugh ? Container(
                    child: Image.network(imageNetWorkLaugh),
                    height: 50, width: 50,
                  ) : Container(),
                  pressCry ? Container(
                    child: Image.network(imageNetWorkCry),
                    height: 50, width: 50,
                  ) : Container(),
                  pressAngry ? Container(
                    child: Image.network(imageNetWorkAngry),
                    height: 50, width: 50,
                  ) : Container(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
