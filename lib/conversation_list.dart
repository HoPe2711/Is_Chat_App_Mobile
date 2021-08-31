
import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:flutter/material.dart';

class ConversationList extends StatefulWidget{
  String roomID;
  String roomName;
  String messageText;
  String roomImageUrl;
  String time;
  bool isMessageRead;
  ConversationList({@required this.roomID,@required this.roomName,@required this.messageText,@required this.roomImageUrl,@required this.time,@required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(widget.roomName);
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatDetailPage(roomID: widget.roomID, roomName: widget.roomName, roomImageUrl: widget.roomImageUrl);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.roomImageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              widget.roomName,
                              style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 6,),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}