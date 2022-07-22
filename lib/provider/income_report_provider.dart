import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Income/income_earing_report_model.dart';

class DailyEarningDetailProvider extends ChangeNotifier {
  // Object Of Model
  DailyEarningReportModel? dailyEarningReportModel;
  WeeklyEariningReportModel? weeklyEariningReportModel;

  // Daily Earning Report Model

  Future<void> dailyEarningReport(BuildContext context,
      {bool fetchInBackground = true, String? dateTime}) async {
    Map<String, dynamic> _parms = {"date": dateTime};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.dailyEarningReport,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print('======${response}');
        if (response != null) {
          dailyEarningReportModel = DailyEarningReportModel.fromJson(response);
          print(dailyEarningReportModel);
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  Future<void> weeklyEarningReport(BuildContext context,
      {bool fetchInBackground = true,
      String? startDate,
      String? endDate}) async {
    Map<String, dynamic> _parms = {
      "start_date": startDate,
      "end_date": endDate
    };
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.weeklyEarningReport,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print('======${response}');
        if (response != null) {
          weeklyEariningReportModel =
              WeeklyEariningReportModel.fromJson(response);
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }
}
