import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/models/search_chat_massage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplaySearchMessage extends StatefulWidget {
  String roomImageUrl;
  String roomName;
  String roomId;
  String textSearch;
  DisplaySearchMessage({Key key, this.roomName, this.roomId, this.textSearch, this.roomImageUrl}) : super(key: key);

  @override
  _DisplaySearchMessageState createState() => _DisplaySearchMessageState();
}

Future<SearchMessage> getSearchMessage(String roomId ,int touch, String word) async {
  final String apiUrl = host_port + "/backend/findChat/" + "$roomId/$touch/$word";

  final response = await http.get(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
  );

  if (response.statusCode == 200)  {
    final String responseString = response.body;
    return searchMessageFromJson(responseString);
  } else {
    return null;
  }
}

class _DisplaySearchMessageState extends State<DisplaySearchMessage> {
  SearchMessage _searchMessage;
  List<Datum> listSearch = [];
  int touch = 0;
  bool loadMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListSearch();
  }

  getListSearch() async {
    SearchMessage searchMessage = await getSearchMessage(widget.roomId, 0, widget.textSearch);
    setState(() {
      _searchMessage = searchMessage;
    });
    listSearch.addAll(_searchMessage.data);
    return _searchMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.roomName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: _searchMessage == null ? CircularProgressIndicator()
          : ListView.builder(
      itemCount: listSearch.length + 1,
      itemBuilder: (context, index){
        if(index == listSearch.length){
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                setState(() {
                  loadMore = true;
                  touch = touch + 1;
                });
                SearchMessage tmpSearch = await getSearchMessage(widget.roomId, touch, widget.textSearch);
                setState(() {
                  listSearch.addAll(tmpSearch.data);
                  loadMore = false;
                });
              },
              child: loadMore == true ? Container(child: Center(child: CircularProgressIndicator())) : Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    "Load more...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
            Colors.orangeAccent,
            child: Text(
              "${listSearch[index].senderName.characters.first.toUpperCase()}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "GoblinOne",
              ),
            ),
          ),
          title: Text(listSearch[index].senderName),
          subtitle: Text(listSearch[index].content),
        );
      }),
    );
  }
}
