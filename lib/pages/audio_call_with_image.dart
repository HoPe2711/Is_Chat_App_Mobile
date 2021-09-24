
import 'package:chat_app_ui_b/constant_colors.dart';
import 'package:chat_app_ui_b/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AudioCallWithImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.asset(
            "assets/full_image.jpg",
            fit: BoxFit.cover,
          ),
          // Black Layer
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jemmy \nWilliams",
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Colors.white),
                  ),
                  VerticalSpacing(of: 10),
                  Text(
                    "Incoming 00:01".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedButton(
                        press: () {},
                        iconSrc: "assets/mic.svg",
                      ),
                      RoundedButton(
                        press: () {},
                        color: kRedColor,
                        iconColor: Colors.white,
                        iconSrc: "assets/end-call.svg",
                      ),
                      RoundedButton(
                        press: () {},
                        iconSrc: "assets/volume.svg",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    this.size = 64,
    @required this.iconSrc,
    this.color = Colors.white,
    this.iconColor = Colors.black,
    @required this.press,
  }) : super(key: key);

  final double size;
  final String iconSrc;
  final Color color, iconColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(size),
      width: getProportionateScreenWidth(size),
      child: FlatButton(
        padding: EdgeInsets.all(15 / 64 * size),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        color: color,
        onPressed: press,
        child: SvgPicture.asset(iconSrc, color: iconColor),
      ),
    );
  }
}