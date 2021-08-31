import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/pages/chat_detail_page.dart';
import 'package:chat_app_ui_b/pages/chat_page.dart';
import 'package:chat_app_ui_b/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOption = [
    ChatPage(),
    //Text('Item 2'),
    ProfilePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJWT();

    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
            webSocketConnectHeaders: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $currentTokenJWT',
            },
            url: socketUrl,
            onConnect: onConnect,
            onWebSocketError: (dynamic error) =>
                print(error.toString()),
          ));
      stompClient.activate();
    }
  }
  getJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentTokenJWT = prefs.getString("currentTokenJWT");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Chats"),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.group_work),
          //   title: Text("Channels"),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}


