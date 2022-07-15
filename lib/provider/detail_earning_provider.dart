import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Income/detail_earning_model.dart';

class DetailEarningProvider extends ChangeNotifier {
  DetailEarningReportModel? detailEarningReportModel;

  Future<void> dailyDetailEarningReport(BuildContext context,
      {bool fetchInBackground = true, String? dateTime}) async {
    Map<String, dynamic> _parms = {"date": dateTime};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.dailyEarningDetailReport,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print('======response${response}');
        if (response != null) {
          detailEarningReportModel =
              DetailEarningReportModel.fromJson(response);
        }
        print(detailEarningReportModel);
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }
}
