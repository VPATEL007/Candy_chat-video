import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/Helper/apple_login_helper.dart';
import 'package:video_chat/app/Helper/facebook_login_helper.dart';
import 'package:video_chat/app/Helper/google_signin_helper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
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
  bool? isAccepted = true;

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
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Checkbox(
                      activeColor: ColorConstants.facebook,
                      value: isAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          isAccepted = value;
                        });
                      },
                    ),
                  ),
                  // ''
                  Flexible(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'I accept privacy policy and terms of use ',
                          style: appTheme?.white14Normal,
                        ),
                        TextSpan(
                          text: 'privacy policy and terms of use',
                          style: appTheme?.white14Normal
                              .copyWith(color: ColorConstants.facebook),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://mjmedia.live/privacy-policy');
                            },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              if (Platform.isIOS)
                getButton(
                    icApple,
                    "Continue with Apple",
                    Colors.black,
                    isAccepted == true
                        ? () {
                            int? langId = context
                                .read<LanguageProvider>()
                                .selctedLanguages
                                ?.id;
                            String deviceId =
                                app.resolve<PrefUtils>().deviceId ?? "";
                            Map<String, dynamic> req = {
                              "device_id": deviceId,
                              "language_id": langId
                            };
                            print(req);
                            AppleLoginHealper.shared.login(context, req, () {});
                          }
                        : () {
                            showLoginMessage(context);
                          }),
              SizedBox(
                height: getSize(12),
              ),
              getButton(
                  icFacebook,
                  "Continue with Facebook",
                  ColorConstants.facebook,
                  isAccepted == true
                      ? () {
                          int? langId = context
                              .read<LanguageProvider>()
                              .selctedLanguages
                              ?.id;
                          String deviceId =
                              app.resolve<PrefUtils>().deviceId ?? "";
                          Map<String, dynamic> req = {
                            "device_id": deviceId,
                            "language_id": langId
                          };
                          print(req);
                          FacebookLoginHelper.shared
                              .loginWithFacebook(context, req, () {});
                        }
                      : () {
                          showLoginMessage(context);
                        }),
              SizedBox(
                height: getSize(12),
              ),
              getButton(
                  icGoogle,
                  "Continue with Google",
                  Colors.white,
                  isAccepted == true
                      ? () {
                          int? langId = context
                              .read<LanguageProvider>()
                              .selctedLanguages
                              ?.id;
                          String deviceId =
                              app.resolve<PrefUtils>().deviceId ?? "";
                          Map<String, dynamic> req = {
                            "device_id": deviceId,
                            "language_id": langId
                          };
                          GoogleSignInHelper.instance
                              .handleSignIn(context, req);
                        }
                      : () {
                          showLoginMessage(context);
                        }),
              SizedBox(
                height: getSize(12),
              ),
              Visibility(
                visible: false,
                child: getButton(
                    icGuest,
                    "Continue with Guest",
                    Colors.white,
                    isAccepted == true
                        ? () async {
                            int? langId = context
                                .read<LanguageProvider>()
                                .selctedLanguages
                                ?.id;
                            String deviceId =
                                app.resolve<PrefUtils>().deviceId ?? "";
                            Map<String, dynamic> req = {
                              "device_id": deviceId,
                              "language_id": langId
                            };
                            print(req);
                            await CommonApiHelper.shared
                                .callGuestLogintApi(context, req, () {}, () {});
                            NavigationUtilities.pushReplacementNamed(
                                Gender.route);
                          }
                        : () {
                            showLoginMessage(context);
                          }),
              )
            ],
          ),
        ),
      ),
    );
  }

  showLoginMessage(context) {
    View.showMessage(context, 'Please accept terms and conditions');
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
