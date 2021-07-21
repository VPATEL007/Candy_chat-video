import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_chat/app/constant/EnumConstant.dart';

import '../app.export.dart';

// AppConfiguration Constant string
const CONFIG_LOGIN = "LOGIN";
const CONFIG_MOBILE_VERIFICATION = "MOBILE_VERIFICATION";
const CONFIG_BANK_DETAIL = "BANK_DETAIL";
const CONFIG_DOC_VERIFICATION = "DOC_VERIFICATION";

class AppNavigation {
  static final AppNavigation shared = AppNavigation();

  // Configuration _configuration;

  Future<void> init() async {
    // code
    // _configuration = AppConfiguration.shared.configuration;
  }

  void goNextFromSplash() {
    // if (!app.resolve<PrefUtils>().isShowIntro()) {
    //   // show Intro
    //   movetoIntro();
    // } else
    if (app.resolve<PrefUtils>().isUserLogin()) {
      //Home
      moveToHome();
    } else {
      //Login
      moveToLogin();
    }
  }

  void moveToHome() {
    // NavigationUtilities.pushReplacementNamed(DrawerPage.route,
    //     type: RouteType.fade);
  }

  void moveToLogin() {
    // NavigationUtilities.pushReplacementNamed(LoginScreen.route);
  }
}
