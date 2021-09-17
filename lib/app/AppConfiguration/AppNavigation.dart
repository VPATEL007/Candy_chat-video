import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/Helper/socket_helper.dart';
import 'package:video_chat/components/Screens/Auth/Login.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';
import 'package:video_chat/components/Screens/Profile/edit_profile.dart';
import 'package:video_chat/provider/followes_provider.dart';

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

  Future<void> moveToHome() async {
    NetworkClient.getInstance
        .showLoader(NavigationUtilities.key.currentState.overlay.context);
    await Provider.of<FollowesProvider>(
            NavigationUtilities.key.currentState.overlay.context,
            listen: false)
        .fetchMyProfile(NavigationUtilities.key.currentState.overlay.context);

    NetworkClient.getInstance.hideProgressDialog();
    isValidProfile();

    // SocketHealper.shared.connect();
    // NavigationUtilities.pushReplacementNamed(Home.route, type: RouteType.fade);
    // CommonApiHelper.shared.appStart();
    // CommonApiHelper.shared.updateFCMToken();
  }

  isValidProfile() {
    var provider = Provider.of<FollowesProvider>(
        NavigationUtilities.key.currentState.overlay.context,
        listen: false);
    if (provider?.userModel?.userName == null ||
        provider.userModel.userName.isEmpty ||
        provider.userModel.userImages == null ||
        provider.userModel.userImages.isEmpty) {
      NavigationUtilities.pushReplacementNamed(EditProfileScreen.route,
          type: RouteType.fade);
    } else {
      SocketHealper.shared.connect();
      NavigationUtilities.pushReplacementNamed(Home.route,
          type: RouteType.fade);
      CommonApiHelper.shared.appStart();
      CommonApiHelper.shared.updateFCMToken();
    }
  }

  void logOut() {
    NavigationUtilities.pushReplacementNamed(LanguageSelection.route);
    SocketHealper.shared.disconnect();
    AgoraService.instance.logOut();
  }

  void moveToLogin() {
    NavigationUtilities.pushReplacementNamed(Login.route);
  }
}
