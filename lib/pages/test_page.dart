// import 'package:chat_app_ui_b/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// showNotification(String content) async {
//   var android = new AndroidNotificationDetails(
//       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//       priority: Priority.high, importance: Importance.max);
//   var iOS = new IOSNotificationDetails();
//   var platform = new NotificationDetails(android: android, iOS: iOS);
//   await flutterLocalNotificationsPlugin.show(
//       0,
//       'Chat App',
//       'New message ---$content---',
//       platform,
//       payload: 'hear is payload');
// }
//
// Future onSelectNotification(String payload) async {
//   debugPrint("payload : $payload");
// }
//
// class TestPage extends StatefulWidget {
//   const TestPage({Key key}) : super(key: key);
//
//   @override
//   _TestPageState createState() => _TestPageState();
// }
//
//
// class _TestPageState extends State<TestPage> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Test Notification"),
//       ),
//       body: Center(
//         child: TextButton(
//           onPressed: (){
//             showNotification("send");
//           },
//           child: Text("Press"),
//         ),
//       ),
//     );
//   }
// }
