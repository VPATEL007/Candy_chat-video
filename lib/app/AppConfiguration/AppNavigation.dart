import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/Helper/socket_helper.dart';
import 'package:video_chat/components/Screens/Auth/Login.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';

import '../app.export.dart';

// AppConfiguration Constant string

class AppNavigation {
  static final AppNavigation shared = AppNavigation();

  Future<void> init() async {}

  void goNextFromSplash() {
    if (!app.resolve<PrefUtils>().isShowIntro() ||
        app.resolve<PrefUtils>().selectedLanguage == null) {
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
    SocketHealper.shared.connect();
    NavigationUtilities.pushReplacementNamed(Home.route, type: RouteType.fade);
    CommonApiHelper.shared.appStart();
    CommonApiHelper.shared.updateFCMToken();
  }

  void logOut() {
    SocketHealper.shared.disconnect();
    NavigationUtilities.pushReplacementNamed(LanguageSelection.route);
  }

  void moveToLogin() {
    NavigationUtilities.pushReplacementNamed(Login.route);
  }
}
