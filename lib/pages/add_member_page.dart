
import 'package:chat_app_ui_b/main.dart';
import 'package:chat_app_ui_b/models/find_display_name_model.dart';
import 'package:chat_app_ui_b/pages/member_page.dart';
import 'package:chat_app_ui_b/title_add_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMemberPage extends StatefulWidget {
  String roomId;
  AddMemberPage({Key key, this.roomId}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

Future<FindUser> findDisplayName(String displayName, int touch) async {

  final String apiUrl = host_port + "/backend/auth/find_user/$displayName/$touch";

  final response = await http.get(
    apiUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $currentTokenJWT',
    },
  );
  if (response.statusCode == 200){
    final responseString = response.body;
    return findUserFromJson(responseString);
  } else {
    return null;
  }
}


class _AddMemberPageState extends State<AddMemberPage> {
  TextEditingController _searchController = TextEditingController();
  FindUser _findUser;
  List<String> listTextAdd = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => MemberPage(roomID: widget.roomId)));
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(child: Text("Add Members",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (text) async {
                  print(text);
                  FindUser findUser = await findDisplayName(text, 0);
                  setState(() {
                    _findUser = findUser;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            _findUser == null ? Container() : ListView.builder(
              itemCount: _findUser.data.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return TitleAddUserWidget(
                  userImageUrl: "https://i1.wp.com/roohentertainment.com/wp-content/uploads/2018/06/user-avatar-1.png?ssl=1",
                  displayName: _findUser.data[index].displayName,
                  username: _findUser.data[index].username,
                  email: _findUser.data[index].email,
                  roomId: widget.roomId,
                  userId: _findUser.data[index].id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
