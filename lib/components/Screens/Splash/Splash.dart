import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/provider/language_provider.dart';

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
        () => (goToNext()),
      );
    });
  }

  goToNext() async {
    AppNavigation.shared.goNextFromSplash();
    await AgoraService.instance.initialize(AGORA_APPID);
    CommonApiHelper.shared.getRTMToken(context);
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
                Image.asset(
                  splashLogo,
                  width: getSize(108),
                ),
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
