import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(
        Duration(seconds: 2),
        () => (gotuNextScreen()),
      );
    });
  }

  gotuNextScreen() {
    AppNavigation.shared.goNextFromSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorPrimary,
        bottomSheet: Image.asset(
          splashBottom,
          width: MathUtilities.screenWidth(context),
        ),
        body: SlideFadeInAnimation(
          duration: const Duration(milliseconds: 1800),
          delay: Duration.zero,
          offset: const Offset(0, 300),
          curve: Curves.easeOutCubic,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(splashLogo),
                SizedBox(
                  height: getSize(33),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getColorText("Random", ColorConstants.red, fontSize: 35),
                    SizedBox(
                      width: getSize(8),
                    ),
                    getColorText("video", ColorConstants.black, fontSize: 35),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getColorText("chat", ColorConstants.black, fontSize: 35),
                    SizedBox(
                      width: getSize(8),
                    ),
                    getColorText("app", ColorConstants.red, fontSize: 35),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
