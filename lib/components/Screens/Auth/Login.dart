import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class Login extends StatefulWidget {
  static const route = "Login";
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      body: Container(
        height: MathUtilities.screenHeight(context),
        width: MathUtilities.screenWidth(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(loginBg),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Image.asset(loginLogo),
              SizedBox(
                height: getSize(29),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getText("Random", Colors.white),
                  SizedBox(
                    width: getSize(8),
                  ),
                  getText("video", ColorConstants.red)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getText("chat", Colors.white),
                  SizedBox(
                    width: getSize(8),
                  ),
                  getText("app", Colors.white)
                ],
              ),
              SizedBox(
                height: getSize(12),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
                child: Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                    textAlign: TextAlign.center,
                    style: appTheme.white14Normal),
              ),
              // SizedBox(
              //   height: getSize(26),
              // ),
              Spacer(),
              getButton(icApple, "Continue with Apple", Colors.black),
              SizedBox(
                height: getSize(12),
              ),
              getButton(icFacebook, "Continue with Facebook",
                  ColorConstants.facebook),
              SizedBox(
                height: getSize(12),
              ),
              getButton(icGoogle, "Continue with Google", Colors.white),
              SizedBox(
                height: getSize(12),
              ),
              getButton(icGuest, "Continue with Guest", Colors.white),
              SizedBox(
                height: getSize(12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getButton(String image, String title, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
      child: Container(
        height: getSize(52),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            getSize(16),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: getSize(26),
            ),
            Image.asset(
              image,
              height: getSize(22),
              width: getSize(22),
            ),
            SizedBox(
              width: getSize(22),
            ),
            Text(
              title,
              style: color == Colors.white
                  ? appTheme.black16Bold.copyWith(fontSize: getFontSize(14))
                  : appTheme.white14Bold,
            )
          ],
        ),
      ),
    );
  }

  getText(String text, Color color) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: getFontSize(25),
            color: color,
            fontWeight: FontWeight.w800));
  }
}
