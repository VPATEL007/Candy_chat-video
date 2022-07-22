import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Income/detail_earning_model.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';

class DetailEarningProvider extends ChangeNotifier {
  DetailEarningReportModel? detailEarningReportModel;

  List<Details> _videoDetailEarningList = [];

  List<Details> get videoDetailEarningList => this._videoDetailEarningList;

  set videoDetailEarningList(List<Details> value) =>
      this._videoDetailEarningList = value;

  List<Details> _giftsEarningList = [];

  List<Details> get giftsEarningList => this._giftsEarningList;

  set giftsEarningList(List<Details> value) => this._giftsEarningList = value;

  List<Details> _matchEarningList = [];

  List<Details> get matchEarningList => this._matchEarningList;

  set matchEarningList(List<Details> value) => this._matchEarningList = value;

  List<Details> _referalEarningList = [];

  List<Details> get referalEarningList => this._referalEarningList;

  set referalEarningList(List<Details> value) =>
      this._referalEarningList = value;

  List<Details> _albumsEarningList = [];

  List<Details> get albumsEarningList => this._albumsEarningList;

  set albumsEarningList(List<Details> value) => this._albumsEarningList = value;

  Future<void> dailyDetailEarningReport(BuildContext context,
      {bool fetchInBackground = true,
      String? dateTime,
      int pageNumber = 1}) async {
    Map<String, dynamic> _parms = {"date": dateTime};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command:
          ApiConstants.dailyEarningDetailReport + 'page=$pageNumber&pageSize=5',
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print('======response${response}');

        if (response != null) {
          detailEarningReportModel =
              DetailEarningReportModel.fromJson(response);
          List<Details> videoArrList = detailEarningModelFromJson(
              jsonEncode(response["vidocall"]['details']));
          List<Details> giftList = detailEarningModelFromJson(
              jsonEncode(response["gifts"]['details']));
          List<Details> matchList = detailEarningModelFromJson(
              jsonEncode(response["match"]['details']));
          List<Details> referalList = detailEarningModelFromJson(
              jsonEncode(response["refral"]['details']));
          List<Details> albumsList = detailEarningModelFromJson(
              jsonEncode(response["albums"]['details']));

          if (pageNumber == 1) {
            videoDetailEarningList = videoArrList;
            giftsEarningList = giftList;
            matchEarningList = matchList;
            referalEarningList = referalList;
            albumsEarningList = albumsList;
          } else {
            videoDetailEarningList.addAll(videoArrList);
            giftsEarningList.addAll(giftList);
            matchEarningList.addAll(matchList);
            referalEarningList.addAll(referalList);
            albumsEarningList.addAll(albumsList);
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
}
