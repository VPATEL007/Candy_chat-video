import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';

import '../app.export.dart';

// AppConfiguration Constant string

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
    // if (app.resolve<PrefUtils>().isUserLogin()) {
    //   //Home
    //   moveToHome();
    // } else {
    //   //Login
    //   moveToLogin();
    // }

    NavigationUtilities.pushReplacementNamed(LanguageSelection.route,
        type: RouteType.fade);
  }

  void moveToHome() {
    NavigationUtilities.pushReplacementNamed(Home.route, type: RouteType.fade);
  }

  void moveToLogin() {
    // NavigationUtilities.pushReplacementNamed(LoginScreen.route);
  }
}
