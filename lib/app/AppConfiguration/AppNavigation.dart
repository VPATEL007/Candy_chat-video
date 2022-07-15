import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/Helper/socket_helper.dart';
import 'package:video_chat/components/Screens/Auth/Login.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';
import 'package:video_chat/components/Screens/Leaderboard/Leaderboard.dart';
import 'package:video_chat/components/Screens/OnboardingVerfication/VerificationInvitation.dart';
import 'package:video_chat/components/Screens/Profile/edit_profile.dart';
import 'package:video_chat/provider/followes_provider.dart';

import '../../components/Screens/VideoCall/VideoCall.dart';
import '../app.export.dart';
import '../utils/apps_flyer/apps_flyer_keys.dart';
import '../utils/apps_flyer/apps_flyer_service.dart';

// AppConfiguration Constant string

class AppNavigation {
  static final AppNavigation shared = AppNavigation();

  Future<void> init() async {}

  void goNextFromSplash(context) {
    if (!app.resolve<PrefUtils>().isShowIntro() ||
        app.resolve<PrefUtils>().selectedLanguages == null) {
      //show Intro
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LanguageSelection()),
          (route) => false);
    } else if (app.resolve<PrefUtils>().isUserLogin()) {
      //Home
      moveToHome(context);
    } else {
      //Login
      moveToLogin(context);
    }
  }

  Future<void> moveToHome(context) async {
    NetworkClient.getInstance
        .showLoader(NavigationUtilities.key.currentState!.overlay!.context);
    await Provider.of<FollowesProvider>(
            NavigationUtilities.key.currentState!.overlay!.context,
            listen: false)
        .fetchMyProfile(NavigationUtilities.key.currentState!.overlay!.context);

    // NetworkClient.getInstance.hideProgressDialog();
    isValidProfile(context);

    SocketHealper.shared.connect();
    // NavigationUtilities.pushReplacementNamed(Home.route, type: RouteType.fade);
    // CommonApiHelper.shared.appStart();
    // CommonApiHelper.shared.updateFCMToken();
  }

  isValidProfile(context) {
    try {
      var userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      print('userId==> $userId');
      var email = app.resolve<PrefUtils>().getUserDetails()?.email;
      print('email==> $email');
      final Map eventValues = {"af_email": "$email", "af_userid": "$userId"};
      AppsFlyerService.appsFlyerService
          .logData(AppsFlyerKeys.appOpen, eventValues);
    } catch (e) {
      print('appsFlyer event error af_email: $e');
    }

    var provider = Provider.of<FollowesProvider>(
        NavigationUtilities.key.currentState!.overlay!.context,
        listen: false);
    if (provider.userModel?.userName == null ||
        provider.userModel?.userName?.isEmpty == true ||
        provider.userModel?.userImages == null ||
        provider.userModel?.userImages?.isEmpty == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => EditProfileScreen(isFromSignUp: true,)),
          (route) => false);
    } else {
      SocketHealper.shared.connect();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => LeaderBoard()), (route) => false);

      CommonApiHelper.shared.appStart();
      CommonApiHelper.shared.updateFCMToken();
    }
  }

  void logOut() {
    NavigationUtilities.pushReplacementNamed(LanguageSelection.route);
    SocketHealper.shared.disconnect();
    AgoraService.instance.logOut();
  }

  void moveToLogin(context) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
  }
}
