import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool clickHome = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page pub.dev"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: (){
              setState(() {
                clickHome = !clickHome;
              });
              print(clickHome);
            },
          ),
        ],
      ),
      body: clickHome == true ? WebView(
          initialUrl: 'https://pub.dev/',
          javascriptMode: JavascriptMode.unrestricted,
      ) : Container(),
    );
  }
}
