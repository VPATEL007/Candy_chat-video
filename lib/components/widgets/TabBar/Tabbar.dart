import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/Chat/ChatList.dart';
import 'package:video_chat/components/Screens/Discover/Discover.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Profile/Profile.dart';

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
          left: getSize(35),
          right: getSize(35),
          bottom: MathUtilities.safeAreaBottomHeight(context) > 20
              ? getSize(26)
              : getSize(16),
          top: getSize(21)),
      child: Container(
        height: getSize(74),
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
              child:
                  getTabItem(widget.screen == TabType.Home, "tabHome", "Home"),
            ),
            InkWell(
              onTap: () {
                NavigationUtilities.pushReplacementNamed(Discover.route);
              },
              child: getTabItem(
                  widget.screen == TabType.Discover, "tablike", "Discovery"),
            ),
            InkWell(
              onTap: () {
                NavigationUtilities.pushReplacementNamed(ChatList.route);
              },
              child: getTabItem(
                  widget.screen == TabType.Chat, "tabChat", "Messages"),
            ),
            InkWell(
                onTap: () {
                  NavigationUtilities.pushReplacementNamed(Profile.route);
                },
                child: getTabProfileItem(widget.screen == TabType.Profile)),
          ],
        ),
      ),
    );
  }

  Widget getTabProfileItem(bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white.withOpacity(isSelected ? 1 : 0.6),
                      width: 1),
                  borderRadius: BorderRadius.circular(
                    18,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  icTemp,
                  height: 18,
                  width: 18,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: getSize(6),
        ),
        Text(
          "Profile",
          style: appTheme.white12Normal.copyWith(
              fontWeight: FontWeight.w500,
              color:
                  isSelected ? Colors.white : Colors.white.withOpacity(0.36)),
        )
      ],
    );
  }

  Widget getTabItem(bool isSelected, String icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
          child: Center(
            child: Image.asset(
              "assets/Tab/$icon" + (isSelected ? "Selected.png" : ".png"),
              height: getSize(18),
              width: getSize(18),
            ),
          ),
        ),
        SizedBox(
          height: getSize(6),
        ),
        Text(
          title,
          style: appTheme.white12Normal.copyWith(
              fontWeight: FontWeight.w500,
              color:
                  isSelected ? Colors.white : Colors.white.withOpacity(0.36)),
        )
      ],
    );
  }
}
