import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/theme/app_theme.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Screens/Setting/BlockList.dart';
import 'package:video_chat/components/Screens/Setting/FavouriteList.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(context, "Settings",
            isWhite: true, leadingButton: getBackButton(context)),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(
              left: getSize(30), right: getSize(30), top: getSize(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                getListItem("Favourite", () {
                  NavigationUtilities.push(FavouriteList());
                }),
                getListItem("Blocked List", () {
                  NavigationUtilities.push(BlockList());
                }),
                getListItem("Rate Us", () {}),
                getListItem("Privacy Policy", () {}),
                getListItem("Feedback", () {}),
                getListItem("About Us", () {})
              ],
            ),
          ),
        )));
  }

  getListItem(String text, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: getSize(21)),
        child: Container(
          width: MathUtilities.screenWidth(context),
          decoration: BoxDecoration(
            color: fromHex("#F6F6F6"),
            borderRadius: BorderRadius.circular(
              getSize(10),
            ),
          ),
          child: Padding(
              padding: EdgeInsets.all(getSize(22)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: appTheme.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Image.asset(
                    icDetail,
                    height: getSize(18),
                    width: getSize(18),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
