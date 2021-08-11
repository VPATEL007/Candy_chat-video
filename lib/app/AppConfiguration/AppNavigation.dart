import 'package:video_chat/components/Screens/Auth/Login.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';

import '../app.export.dart';

// AppConfiguration Constant string

class AppNavigation {
  static final AppNavigation shared = AppNavigation();

  Future<void> init() async {}

  void goNextFromSplash() {
    if (!app.resolve<PrefUtils>().isShowIntro()) {
      //show Intro
      NavigationUtilities.pushReplacementNamed(LanguageSelection.route,
          type: RouteType.fade);
    } else if (app.resolve<PrefUtils>().isUserLogin()) {
      //Home
      moveToHome();
    } else {
      //Login
      moveToLogin();
    }
  }

  void moveToHome() {
    NavigationUtilities.pushReplacementNamed(Home.route, type: RouteType.fade);
  }

  void moveToLogin() {
    NavigationUtilities.pushReplacementNamed(Login.route);
  }
}
