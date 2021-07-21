import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';

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
                    Text("Random",
                        style: TextStyle(
                            fontSize: getFontSize(35),
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      width: getSize(8),
                    ),
                    Text("video",
                        style: TextStyle(
                            fontSize: getFontSize(35),
                            color: ColorConstants.black,
                            fontWeight: FontWeight.w700))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("chat",
                        style: TextStyle(
                            fontSize: getFontSize(35),
                            color: ColorConstants.black,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      width: getSize(8),
                    ),
                    Text("app",
                        style: TextStyle(
                            fontSize: getFontSize(35),
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w700))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
