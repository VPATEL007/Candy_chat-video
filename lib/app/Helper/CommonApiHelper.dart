import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Language/Language.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Auth/Gender.dart';
import 'package:video_chat/main.dart';

import '../app.export.dart';

class CommonApiHelper {
  static var shared = CommonApiHelper();

//Login
  callLoginApi(Map<String, dynamic> req, BuildContext context, Function success,
      Function failure) {
    NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.login,
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();

        if (response["userData"] != null) {
          UserModel model = UserModel.fromJson(response["userData"]);
          app.resolve<PrefUtils>().saveUser(model, isLoggedIn: true);
        }

        if (response["tokenData"] != null) {
          app
              .resolve<PrefUtils>()
              .saveUserToken(response["tokenData"]["accessToken"]);
          app
              .resolve<PrefUtils>()
              .saveRefereshToken(response["tokenData"]["accessToken"]);
        }
        NavigationUtilities.pushReplacementNamed(Gender.route,
            type: RouteType.fade);

        success();
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
        failure();
      },
    );
  }

//Language
  Future callLanguageListApi(
      BuildContext context,
      Function(List<LanguageModel>) success,
      Function failure,
      bool fetchInBackground) async {
    Map<String, dynamic> req = {};
    req["status"] = 1;

    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.allLanguage,
      method: MethodType.Get,
      params: req,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        List<dynamic> list = response;
        if (list != null) {
          List<LanguageModel> arrList =
              list.map((obj) => LanguageModel.fromJson(obj)).toList();
          success(arrList);
          return;
        }
        failure();
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
        failure();
      },
    );
  }

  //Language
  Future callGuestLogintApi(BuildContext context, Map<String, dynamic> req,
      Function success, Function failure) async {
    NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.guestLogin,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: req,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();
        if (response["userData"] != null) {
          UserModel model = UserModel.fromJson(response["userData"]);
          app.resolve<PrefUtils>().saveUser(model, isLoggedIn: true);
        }

        if (response["tokenData"] != null) {
          app
              .resolve<PrefUtils>()
              .saveUserToken(response["tokenData"]["accessToken"]);
          app
              .resolve<PrefUtils>()
              .saveRefereshToken(response["tokenData"]["accessToken"]);
        }

        NavigationUtilities.pushReplacementNamed(Gender.route,
            type: RouteType.fade);
        success();
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
        failure();
      },
    );
  }
}
