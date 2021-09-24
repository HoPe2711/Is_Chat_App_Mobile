
import 'package:chat_app_ui_b/constant_colors.dart';
import 'package:chat_app_ui_b/pages/audio_call_with_image.dart';
import 'package:chat_app_ui_b/pages/dial_screen.dart';
import 'package:chat_app_ui_b/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: demoData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.53,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => demoData[index]["isCalling"]
            ? UserCallingCard(
          name: "Steve jon",
          image: "assets/full_image.jpg",
        )
            : Image.asset(
          demoData[index]['image'],
          fit: BoxFit.cover,
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Container buildBottomNavBar() {
    return Container(
      color: kBackgoundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              RoundedButton(
                color: kRedColor,
                iconColor: Colors.white,
                size: 48,
                iconSrc: "assets/close.svg",
                press: () {},
              ),
              Spacer(flex: 5),
              RoundedButton(
                color: Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                iconSrc: "assets/volume.svg",
                press: () {},
              ),
              Spacer(),
              RoundedButton(
                color: Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                iconSrc: "assets/mic.svg",
                press: () {},
              ),
              Spacer(),
              RoundedButton(
                color: Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                iconSrc: "assets/video-camera.svg",
                press: () {},
              ),
              Spacer(),
              RoundedButton(
                color: Color(0xFF2C384D),
                iconColor: Colors.white,
                size: 48,
                iconSrc: "assets/repeat.svg",
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/back.svg"),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/user.svg",
            height: 28,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class UserCallingCard extends StatelessWidget {
  const UserCallingCard({
    Key key,
    @required this.name,
    @required this.image,
  }) : super(key: key);

  final String name, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgoundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DialUserPic(
            size: 112,
            image: image,
          ),
          VerticalSpacing(of: 10),
          Text(
            name,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          VerticalSpacing(of: 5),
          Text(
            "Calling…",
            style: TextStyle(color: Colors.white60),
          )
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> demoData = [
  {
    "isCalling": false,
    "name": "User 1",
    "image": "assets/full_image.jpg",
  },
  {
    "isCalling": true,
    "name": "Steve jon",
    "image": "assets/full_image.jpg",
  },
  {
    "isCalling": false,
    "name": "User 1",
    "image": "assets/full_image.jpg",
  },
  {
    "isCalling": false,
    "name": "User 1",
    "image": "assets/full_image.jpg",
  },
];