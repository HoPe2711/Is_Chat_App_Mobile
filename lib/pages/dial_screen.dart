
import 'package:chat_app_ui_b/constant_colors.dart';
import 'package:chat_app_ui_b/pages/audio_call_with_image.dart';
import 'package:chat_app_ui_b/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBackgoundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Anna williams",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.white),
              ),
              Text(
                "Calling…",
                style: TextStyle(color: Colors.white60),
              ),
              VerticalSpacing(),
              DialUserPic(image: "assets/full_image.jpg"),
              Spacer(),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  DialButton(
                    iconSrc: "assets/mic.svg",
                    text: "Audio",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/volume.svg",
                    text: "Microphone",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/video-camera.svg",
                    text: "Video",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/message.svg",
                    text: "Message",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/user.svg",
                    text: "Add contact",
                    press: () {},
                  ),
                  DialButton(
                    iconSrc: "assets/voicemail.svg",
                    text: "Voice mail",
                    press: () {},
                  ),
                ],
              ),
              VerticalSpacing(),
              RoundedButton(
                iconSrc: "assets/end-call.svg",
                press: () {},
                color: kRedColor,
                iconColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DialButton extends StatelessWidget {
  const DialButton({
    Key key,
    @required this.iconSrc,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String iconSrc, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(120),
      child: FlatButton(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(20),
        ),
        onPressed: press,
        child: Column(
          children: [
            SvgPicture.asset(
              iconSrc,
              color: Colors.white,
              height: 36,
            ),
            VerticalSpacing(of: 5),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DialUserPic extends StatelessWidget {
  const DialUserPic({
    Key key,
    this.size = 192,
    @required this.image,
  }) : super(key: key);

  final double size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30 / 192 * size),
      height: getProportionateScreenWidth(size),
      width: getProportionateScreenWidth(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.05)
          ],
          stops: [.5, 1],
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
