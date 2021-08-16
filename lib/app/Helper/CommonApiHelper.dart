import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Language/Language.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Model/User/report_reason_model.dart';
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
              .saveRefereshToken(response["tokenData"]["refreshToken"]);
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

  // Match profile list...
  Future callMatchProfileListApi(
      BuildContext context,
      Map<String, dynamic> parms,
      Function(List<MatchProfileModel>) success,
      Function failure,
      bool fetchInBackground) async {
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.matchProfile,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["data"]);
        if (response["data"] != null) {
          List<MatchProfileModel> arrList =
              matchProfileModelFromJson(jsonEncode(response["data"]));
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

  Future callReportReasonApi(
      BuildContext context,
      Function(List<ReportReasonModel>) success,
      Function failure,
      bool fetchInBackground) async {
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.reportReason,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();

        if (response != null) {
          List<ReportReasonModel> arrList =
              reportReasonModelFromJson(jsonEncode(response));
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

  Future callReportReasonSubmitApi(BuildContext context,
      Map<String, dynamic> req, Function success, Function failure) async {
    NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.reportBlock,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: req,
      successCallback: (response, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
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
              .saveRefereshToken(response["tokenData"]["refreshToken"]);
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
