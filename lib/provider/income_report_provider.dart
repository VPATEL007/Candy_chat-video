import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Income/detail_weekly_earning_report_model.dart';
import 'package:video_chat/components/Model/Income/income_earing_report_model.dart';
import 'package:video_chat/components/Model/Income/salary_details_model.dart';

class DailyEarningDetailProvider extends ChangeNotifier {
  // Object Of Model
  DailyEarningReportModel? dailyEarningReportModel;
  WeeklyEariningReportModel? weeklyEariningReportModel;
  SalaryDetailModel? salaryDetailModel;

  List<WeeklyDetailDataModel> _weeklyDetailEarningList = [];

  List<WeeklyDetailDataModel> get weeklyDetailEarningList =>
      this._weeklyDetailEarningList;

  set weeklyDetailEarningList(List<WeeklyDetailDataModel> value) =>
      this._weeklyDetailEarningList = value;

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

  // Weekly Earning Report API
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

  //Weekly Detail Earning API
  Future<void> weeklyDetailEarningReport(BuildContext context,
      {bool fetchInBackground = true,
      int? page,
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
      command: ApiConstants.weeklyDetailEarningReport + 'page=$page&size=5',
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();

        if (response != null) {
          List<WeeklyDetailDataModel> arrList =
              weeklyDetailSalaryModelFromJson(jsonEncode(response));
          if (page == 1) {
            weeklyDetailEarningList = arrList;
          } else {
            weeklyDetailEarningList.addAll(arrList);
          }
        }
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }

  // Salary Details Api

  Future<void> salaryDetails(BuildContext context,
      {bool fetchInBackground = true, String? fromDate}) async {
    Map<String, dynamic> _parms = {
      "fromDate": fromDate,
    };
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.salaryDetails,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        if (response != null) {
          salaryDetailModel = salaryDetailModelFromJson(jsonEncode(response));
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
