import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';

class TabBarWidget extends StatefulWidget {
  TabBarWidget({Key key}) : super(key: key);

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
          bottom: MathUtilities.safeAreaBottomHeight(context) + getSize(16),
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
            Container(
              width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
              child: Center(
                child: Image.asset(icTabHomeSelected),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
              child: Center(
                child: Image.asset(icTabLike),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
              child: Center(
                child: Image.asset(icTabChat),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - getSize(72)) / 4,
              child: Center(
                child: Image.asset(icTabChat),
              ),
            )
          ],
        ),
      ),
    );
  }
}
