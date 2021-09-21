import 'dart:async';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Timer(
        Duration(seconds: 2),
        () => (goToNext()),
      );
    });
  }

  goToNext() async {
    await AgoraService.instance.initialize(AGORA_APPID);
    AppNavigation.shared.goNextFromSplash();
    // FirebaseCrashlytics.instance.crash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorPrimary,
        bottomSheet: Image.asset(
          splashBottom,
          width: MathUtilities.screenWidth(context),
        ),
        body: Center(
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
        ));
  }
}
