import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/Helper/apple_login_helper.dart';
import 'package:video_chat/app/Helper/facebook_login_helper.dart';
import 'package:video_chat/app/Helper/google_signin_helper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/apps_flyer/apps_flyer_keys.dart';
import 'package:video_chat/app/utils/apps_flyer/apps_flyer_service.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Screens/Auth/Gender.dart';
import 'dart:io' show Platform;

import 'package:video_chat/provider/language_provider.dart';

class Login extends StatefulWidget {
  static const route = "Login";

  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    app
        .resolve<PrefUtils>()
        .saveBoolean(app.resolve<PrefUtils>().keyIsShowIntro, true);
    app.resolve<PrefUtils>().saveInt(app.resolve<PrefUtils>().keyIsFromAge, 11);
    app.resolve<PrefUtils>().saveInt(app.resolve<PrefUtils>().keyIsToAge, 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      body: Container(
        height: MathUtilities.screenHeight(context),
        width: MathUtilities.screenWidth(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(loginBgNew),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: getSize(60), right: getSize(60)),
                child: Image.asset(loginLogo),
              ),
              SizedBox(
                height: getSize(29),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getColorText("Random", Colors.white),
                  SizedBox(
                    width: getSize(8),
                  ),
                  getColorText("video", ColorConstants.red)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getColorText("chat", Colors.white),
                  SizedBox(
                    width: getSize(8),
                  ),
                  getColorText("app", Colors.white)
                ],
              ),
              SizedBox(
                height: getSize(12),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
                child: Text(
                    "Welcome to the new world of socializing via video call and chat",
                    textAlign: TextAlign.center,
                    style: appTheme?.white14Normal),
              ),
              Spacer(),
              if (Platform.isIOS)
                getButton(icApple, "Continue with Apple", Colors.black, () {
                  int? langId =
                      context.read<LanguageProvider>().selctedLanguages?.id;
                  String deviceId = app.resolve<PrefUtils>().deviceId ?? "";
                  Map<String, dynamic> req = {
                    "device_id": deviceId,
                    "language_id": langId
                  };
                  print(req);
                  AppleLoginHealper.shared.login(context, req, () {});
                }),
              SizedBox(
                height: getSize(12),
              ),
              getButton(
                  icFacebook, "Continue with Facebook", ColorConstants.facebook,
                  () {
                // AppsFlyerService.appsFlyerService
                //     .logEvent(AppsFlyerKeys.registration, eventValues);
                int? langId =
                    context.read<LanguageProvider>().selctedLanguages?.id;
                String deviceId = app.resolve<PrefUtils>().deviceId ?? "";
                Map<String, dynamic> req = {
                  "device_id": deviceId,
                  "language_id": langId
                };
                print(req);
                FacebookLoginHelper.shared
                    .loginWithFacebook(context, req, () {});
              }),
              SizedBox(
                height: getSize(12),
              ),
              getButton(icGoogle, "Continue with Google", Colors.white, () {
                int? langId =
                    context.read<LanguageProvider>().selctedLanguages?.id;
                String deviceId = app.resolve<PrefUtils>().deviceId ?? "";
                Map<String, dynamic> req = {
                  "device_id": deviceId,
                  "language_id": langId
                };
                GoogleSignInHelper.instance.handleSignIn(context, req);
              }),
              SizedBox(
                height: getSize(12),
              ),
              Visibility(
                visible: true,
                child: getButton(icGuest, "Continue with Guest", Colors.white,
                    () async {
                  int? langId =
                      context.read<LanguageProvider>().selctedLanguages?.id;
                  String deviceId = app.resolve<PrefUtils>().deviceId ?? "";
                  Map<String, dynamic> req = {
                    "device_id": deviceId,
                    "language_id": langId
                  };
                  print(req);
                  await CommonApiHelper.shared
                      .callGuestLogintApi(context, req, () {}, () {});
                  NavigationUtilities.push(Gender());
                }),
              ),
              SizedBox(
                height: getSize(12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getButton(String image, String title, Color color, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Padding(
        padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
        child: Container(
          height: getSize(52),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              getSize(16),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: getSize(26),
              ),
              Image.asset(
                image,
                height: getSize(22),
                width: getSize(22),
              ),
              SizedBox(
                width: getSize(22),
              ),
              Text(
                title,
                style: color == Colors.white
                    ? appTheme?.black16Bold.copyWith(fontSize: getFontSize(14))
                    : appTheme?.white14Bold,
              )
            ],
          ),
        ),
      ),
    );
  }
}
