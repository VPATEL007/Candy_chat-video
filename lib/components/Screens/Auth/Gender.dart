import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class Gender extends StatefulWidget {
  static const route = "Gender";
  Gender({Key key}) : super(key: key);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Select Gender", isWhite: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: getSize(35), right: getSize(35)),
          child: Container(
            width: MathUtilities.screenWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: getSize(70),
                ),
                Image.asset(
                  icMale,
                  height: getSize(140),
                ),
                Image.asset(
                  radioSelected,
                  height: getSize(22),
                ),
                Spacer(),
                Image.asset(
                  icFemale,
                  height: getSize(140),
                ),
                Image.asset(
                  radioSelected,
                  height: getSize(22),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getColorText("Which", Colors.black),
                    SizedBox(
                      width: getSize(6),
                    ),
                    getColorText("Gender?", ColorConstants.redText)
                  ],
                ),
                SizedBox(
                  height: getSize(6),
                ),
                Text(
                  "Choose your favorite gender",
                  style: appTheme.black14Normal,
                ),
                Spacer(),
                getPopBottomButton(context, "Next", () {
                  AppNavigation.shared.moveToHome();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
