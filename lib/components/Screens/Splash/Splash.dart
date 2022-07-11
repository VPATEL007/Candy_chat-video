import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/Helper/socket_helper.dart';
import 'package:video_chat/app/app.export.dart';

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
    await AgoraService.instance.initialize(AGORA_APPID, context);
    AppNavigation.shared.goNextFromSplash();
    SocketHealper.shared.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.mainBgColor,
        // bottomSheet: Image.asset(
        //   splashBottom,
        //   width: MathUtilities.screenWidth(context),
        // ),
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
                  getColorText("Storm", ColorConstants.red, fontSize: 35),
                  SizedBox(
                    width: getSize(8),
                  ),
                  // getColorText("Random", ColorConstants.black, fontSize: 35),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getColorText("Video", ColorConstants.black, fontSize: 35),
                  SizedBox(
                    width: getSize(8),
                  ),
                  getColorText("Chat", ColorConstants.red, fontSize: 35),
                ],
              ),
            ],
          ),
        ));
  }
}
