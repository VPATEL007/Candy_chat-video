import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app.export.dart';

abstract class StatefulScreenWidget extends StatefulWidget {
  StatefulScreenWidget({
    Key key,
  }) : super(key: key);

  // get visaModel => null;
}

abstract class StatefulScreenWidgetState extends State<StatefulScreenWidget> {
  @override
  void initState() {
    super.initState();
    changeNavigationandBottomBarColor();
  }

  Widget getBackGoundImage({String imgName = splashBG}) {
    return Image.asset(
      imgName,
      width: MathUtilities.screenWidth(context),
      height: MathUtilities.screenHeight(context),
      fit: BoxFit.cover,
    );
  }

  double getTopPadding() {
    // return getSize(124);
    return 136;
  }

  double getTotalHeight() {
    return MathUtilities.screenHeight(context) - getTopPadding();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    changeNavigationandBottomBarColor();
  }

  @override
  Widget build(BuildContext context) {
    // return NeumorphicTheme(
    //   themeMode: ThemeMode.light,
    //   theme: NeumorphicThemeData(
    //     lightSource: LightSource.topLeft,
    //     accentColor: NeumorphicColors.accent,
    //     depth: 4,
    //     intensity: 0.5,
    //   ),
    //   child: SizedBox(
    //     width: MathUtilities.screenWidth(context),
    //     height: MathUtilities.screenHeight(context),
    //   ),
    // );
    return AppBackground();
  }

  changeNavigationandBottomBarColor(
      {bool isCustomColor, Color statusBarColor, Color bottomBarColor}) {
    if (isCustomColor != null && isCustomColor == true) {
      // changeStatusColor(statusBarColor);
      // changeNavigationColor(bottomBarColor);
    } else {
      // changeStatusColor(Colors.transparent);
      // changeNavigationColor(Colors.white);

    }

    print("Base class method called");
  }
}
