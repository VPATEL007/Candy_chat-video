import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Notification/recharg_notification_model.dart';

class RechargeNotificationProvider extends ChangeNotifier {
  List<NotificationDataModel> _rechargeNotificationList = [];

  List<NotificationDataModel> get rechargeNotificationList =>
      this._rechargeNotificationList;

  set rechargeNotificationList(List<NotificationDataModel> value) =>
      this._rechargeNotificationList = value;

  Future<void> rechargeNotificationDetail(BuildContext context,
      {bool fetchInBackground = true}) async {
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.rechargeNotification,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) async {
        // getData();
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print('Recharge Notification Responce ======${response}');
        if (response != null) {
          List<NotificationDataModel> videoArrList =
              rechargeNotificationModelFromJson(jsonEncode(response));
          rechargeNotificationList = videoArrList;
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  Future<void> resetRechargeNotificationDetail(BuildContext context,
      {bool fetchInBackground = true}) async {
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.resetRechargeNotification,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) async {
        print('Reset Notification Response===${response}');
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }
}
