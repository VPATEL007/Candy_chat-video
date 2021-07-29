import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/Chat/ChatList.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';

class TabBarWidget extends StatefulWidget {
  TabType screen = TabType.Home;
  TabBarWidget({Key key, this.screen}) : super(key: key);

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getSize(36),
          right: getSize(36),
          bottom: MathUtilities.safeAreaBottomHeight(context) > 20
              ? getSize(26)
              : getSize(16),
          top: getSize(21)),
      child: Container(
        height: getSize(60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorConstants.gradiantStart, ColorConstants.red],
          ),
          borderRadius: BorderRadius.circular(
            getSize(18),
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                NavigationUtilities.pushReplacementNamed(Home.route);
              },
              child: Container(
                width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
                child: Center(
                  child: Image.asset(widget.screen == TabType.Home
                      ? icTabHomeSelected
                      : icTabHome),
                ),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
              child: Center(
                child: Image.asset(
                    widget.screen == TabType.Discover ? icTabLike : icTabLike),
              ),
            ),
            InkWell(
              onTap: () {
                NavigationUtilities.pushReplacementNamed(ChatList.route);
              },
              child: Container(
                width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
                child: Center(
                  child: Image.asset(widget.screen == TabType.Chat
                      ? icTabChatSelected
                      : icTabChat),
                ),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
              child: Center(
                child: Image.asset(icTabProfile),
              ),
            )
          ],
        ),
      ),
    );
  }
}
