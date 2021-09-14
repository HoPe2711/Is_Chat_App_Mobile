import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/message_widget.dart';
import 'package:chat_app_ui_b/models/chat_message_model.dart';
import 'package:chat_app_ui_b/models/history_chat_model.dart';
import 'package:chat_app_ui_b/pages/home_page.dart';
import 'package:chat_app_ui_b/pages/member_page.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

int maxLengthMessage = 20;
final dateFormat = new DateFormat('yy-MM-dd hh:mm:ss');
ScrollController scrollController = ScrollController();
String positionRoomId = "";
MessList tmp = new MessList();

void onConnect(StompFrame frame) {
  print("on connect");
  stompClient.subscribe(
      destination: '/queue' + '/$currentUserID',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentTokenJWT',
      },
      callback: (StompFrame frame) async {
        print("callback");
        if (frame.body != null) {
          Map<String, dynamic> result = json.decode(frame.body);
          print(result);
          if(result['emotion'] == null) {
            if (currentUserID != result['senderId']) {
              showNotification(
                result['senderName'],
                result['chatRoomName'],
                result['content'],
                dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(result['timestamp'])).toString(),
              );
            }
            if (positionRoomId == result['chatRoomId']) tmp.messages = list.messages;
            else getcurrentList(result['chatRoomId']);

            addItem(
              result['id'],
              result['senderId'],
              result['senderName'],
              result['chatRoomId'],
              result['content'],
              result['chatRoomName'],
              dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(result['timestamp'])).toString(),
              [],
            );
            if (positionRoomId == result['chatRoomId']) {
              list.messages = tmp.messages;
              //print(list.toJSONEncodable());
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              );
            }
          } else {
            print(result['emotion']);
            int vt;
            for(int i=0; i < list.messages.length; i++){
              if(result['chatId'] == list.messages[i].id){
                vt = i;
                break;
              }
            }
            print(vt);
            if(list.messages[vt].listEmotions == null){
              list.messages[vt].listEmotions = [];
            }
            list.messages[vt].listEmotions.add(PerEmo(
              senderId: result['senderId'],
              senderName: result['senderName'],
              emotion: result['emotion'],
            ));
            //print(list.toJSONEncodable());
            print(list.toJSONEncodable());
            storage.setItem('${result['chatRoomId']}', list.toJSONEncodable());
          }
        }
      });
}

class Message {
  String id;
  String senderId;
  String senderName;
  String chatRoomId;
  String content;
  List<PerEmo> listEmotions;
  //PerEmo perEmo;
  String chatRoomName;
  String timestamp;

  Message(
      {@required this.senderId,
      @required this.id,
      @required this.senderName,
      @required this.chatRoomId,
      @required this.content,
      this.listEmotions,
        //this.perEmo,
      @required this.chatRoomName,
      @required this.timestamp});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['senderId'] = senderId;
    m['id'] = id;
    m['senderName'] = senderName;
    m['chatRoomId'] = chatRoomId;
    m['content'] = content;
    listEmotions == null ? m['listEmotions'] = [] :
    m['listEmotions'] = List<dynamic>.from(listEmotions.map((x) => x.toJSONEncodable()));
    //m['perEmo'] = perEmo.toJSONEncodable();
    m['chatRoomName'] = chatRoomName;
    m['timestamp'] = timestamp;

    return m;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return new Message(
      id: json['id'].toString(),
      senderId: json['senderId'].toString(),
      senderName: json['senderName'].toString(),
      chatRoomId: json['chatRoomId'].toString(),
      content: json['content'].toString(),
      listEmotions: List<PerEmo>.from(json["listEmotions"].map((x) => PerEmo.fromJson(x))),
      //perEmo: PerEmo.fromJson(json['perEmo']),
      chatRoomName: json['chatRoomName'].toString(),
      timestamp: json['timestamp'].toString(),
    );
  }
}

class PerEmo{
  String senderId;
  String senderName;
  String emotion;
  PerEmo({this.senderId, this.senderName, this.emotion});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['senderId'] = senderId;
    m['senderName'] = senderName;
    m['emotion'] = emotion;

    return m;
  }

  factory PerEmo.fromJson(Map<String, dynamic> json) {
    return new PerEmo(
      senderId: json['senderId'],
      senderName: json['senderName'],
      emotion: json['emotion'],
    );
  }
}

class MessList {
  List<Message> messages = List<Message>();

  toJSONEncodable() {
    return messages.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

final MessList list = new MessList();
final LocalStorage storage = new LocalStorage('todo_app');

StompClient stompClient;

TextEditingController _inputController = TextEditingController();
//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

final MessList listHistory = MessList();



getcurrentList(String roomId){
  tmp.messages = [];
  print(storage.getItem('$roomId'));
  var items = storage.getItem('$roomId');

  if (items != null) {
    tmp.messages = List<Message>.from(
      (items as List).map(
        (item) => Message(
          id: item['id'],
          senderId: item['senderId'],
          senderName: item['senderName'],
          chatRoomId: item['chatRoomId'],
          content: item['content'],
          //listEmotions: item['listEmotions'],
          listEmotions: List<PerEmo>.from(item['listEmotions'].map((x) => PerEmo.fromJson(x))),
          chatRoomName: item['chatRoomName'],
          timestamp: item['timestamp'],
        ),
      ),
    );
  }
  list.messages = tmp.messages;
  //print("get list ${list.toJSONEncodable()}");
  if (list.messages == null) {
    list.messages = [];
  }
  //return tmp.messages;
}

addItem(String id, String senderId, String senderName, String chatRoomId, String content, String chatRoomName, String timestamp, List<PerEmo> listEmo) {
  //setState(() {
  final item = new Message(
      id: id,
      senderId: senderId,
      senderName: senderName,
      chatRoomId: chatRoomId,
      content: content,
      listEmotions: listEmo,
      chatRoomName: chatRoomName,
      timestamp: timestamp);

  tmp.messages.insert(0, item);
  saveToStorage(chatRoomId);
}

saveToStorage(String chatRoomId) {
  MessList msg = new MessList();
  for (int i=0; i< min(tmp.messages.length, maxLengthMessage) ; i++){
    msg.messages.add(tmp.messages[i]);
  }
  storage.setItem('$chatRoomId', msg.toJSONEncodable());
}

showNotification(String senderName, String chatRoomName, String content, String timestamp) async {
  var android = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: iOS);
  await flutterLocalNotificationsPlugin.show(
      0,
      'Chat App',
      'New message from $senderName to $chatRoomName with $content at $timestamp',
      platform,
      payload: 'hear is payload');
}

Future onSelectNotification(String payload) async {
  debugPrint("payload : $payload");
  //runApp(ChatDetailPage());
}

class ChatDetailPage extends StatefulWidget {
  String roomID;
  String roomName;
  String roomImageUrl;
  ChatDetailPage({Key key, this.roomID, this.roomName, this.roomImageUrl})
      : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

Future<List<Message>> loadHistory(String roomId, int touch) async {
  final String apiUrl = host_port + "/backend/chatHistory/$roomId/$touch";
  final response = await http.get(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseMap = json.decode(response.body);
    var items = responseMap['data'];
    //print(items);

    if (items != null) {
      listHistory.messages = List<Message>.from(
        (items as List).map(
              (item) => Message(
            id: item['id'],
            senderId: item['senderId'],
            senderName: item['senderName'],
            chatRoomId: item['chatRoomId'],
            //listEmotions: item['reactList'],
                listEmotions: List<PerEmo>.from(item['reactList'].map((x) => PerEmo.fromJson(x))),
                content: item['content'],
            chatRoomName: item['chatRoomName'],
                timestamp: dateFormat.format(new DateTime.fromMillisecondsSinceEpoch(item['timestamp'])).toString(),
            //timestamp: item['timestamp'].toString(),
          ),
        ),
      );
    }
    //print(responseString);
    return listHistory.messages;
  } else {
    return null;
  }
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  bool showEmojiKeyboard = false;
  bool visibilityInf = false;
  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "inf"){
        visibilityInf = visibility;
      }
    });
  }

  bool _running = true;
  Stream<String> _clock() async* {
    // This loop will run forever because _running is always true
    while (_running) {
      await Future<void>.delayed(Duration(milliseconds: 100));
      DateTime _now = DateTime.now();
      // This will be displayed on the screen as current time
      yield "${_now.hour} : ${_now.minute} : ${_now.second}";
    }
  }

  bool initialized = false;

  int touch = 0;

  sendMessage(String msg) async {
    if (msg != "") {
      stompClient.send(
        destination: "/app/chat",
        body: jsonEncode(<String, String>{
          "senderId": currentUserID,
          "senderName": currentDisplayName,
          "chatRoomId": widget.roomID,
          "content": msg,
        }),
      );
    }
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.messages = storage.getItem('${widget.roomID}') ?? [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    positionRoomId = widget.roomID;
    getUserID();
    setState(() {
      //getcurrentList(widget.roomID);
    });
    setState(() {
      load0(widget.roomID);
    });
  }
  load0(String roomId) async {
    list.messages = await loadHistory(roomId, 0);
    print(list.toJSONEncodable());
  }


  getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserID = prefs.getString("currentUserID");
    currentDisplayName = prefs.getString("currentDisplayName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink[100],
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage("${widget.roomImageUrl}"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.roomName}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.people),
                  color: Colors.black54,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MemberPage(roomID: widget.roomID)));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black54,
                  onPressed: () {
                    print("${widget.roomID}");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          constraints: BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var items = storage.getItem('${widget.roomID}');

                if (items != null) {
                  list.messages = List<Message>.from(
                    (items as List).map(
                      (item) => Message(
                        senderId: item['senderId'],
                        senderName: item['senderName'],
                        chatRoomId: item['chatRoomId'],
                        content: item['content'],
                        chatRoomName: item['chatRoomName'],
                        timestamp: item['timestamp'],
                      ),
                    ),
                  );
                }
                initialized = true;
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: StreamBuilder(
                        stream: _clock(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: list.messages.length + 1,
                            shrinkWrap: true,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              if (index == list.messages.length) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        touch++;
                                      });
                                      listHistory.messages = await loadHistory(widget.roomID, touch);
                                      list.messages.addAll(listHistory.messages);
                                    },
                                    child: Text("More message ..."),
                                  ),
                                );
                              }
                              return MessageWidget(
                                senderName: list.messages[index].senderName,
                                content: list.messages[index].content,
                                timestamp: list.messages[index].timestamp,
                                id: list.messages[index].id,
                                listEmotions: list.messages[index].listEmotions,
                                // lastEmotion: list.messages[index].listEmotions == null ?
                                // "" : list.messages[index].listEmotions.last.emotion,
                              );
                            },
                          );
                        }),
                  ),
                  Column(
                    children: [
                      showEmojiKeyboard == true ? emojiSelect() : Container(),
                      ListTile(
                        title: TextField(
                          controller: _inputController,
                          decoration: InputDecoration(
                            labelText: 'Input message...',
                          ),
                          onEditingComplete: () {
                            _send(_inputController.text);
                            _inputController.clear();
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.emoji_emotions,
                                color: Colors.pink[300],
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  showEmojiKeyboard = !showEmojiKeyboard;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Colors.pink[300],
                              ),
                              onPressed: () {
                                _send(_inputController.text);
                              },
                              tooltip: 'Send',
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.delete),
                            //   onPressed: _clearStorage,
                            //   tooltip: 'Clear storage',
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }

  _send(String msg) {
    sendMessage(msg);
    _inputController.clear();
  }

  // @override
  // void dispose() {
  //   if (stompClient != null) {
  //     //stompClient.activate();
  //     stompClient.deactivate();
  //     stompClient = null;
  //   }
  //   super.dispose();
  // }
  Widget emojiSelect() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: EmojiPicker(
          rows: 4,
          columns: 7,
          onEmojiSelected: (emoji, category) {
            print(emoji);
            setState(() {
              _inputController.text = _inputController.text + emoji.emoji;
            });
          }),
    );
  }

}
