import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/BlockList/blocklistModel.dart';
import 'package:video_chat/components/Model/User/report_reason_model.dart';

class ReportAndBlockProvider with ChangeNotifier {
  List<ReportReasonModel> _reportReasonList = [];

  List<ReportReasonModel> get reportReasonList => this._reportReasonList;

  set reportReasonList(List<ReportReasonModel> value) =>
      this._reportReasonList = value;

  // Fetch report reason...
  Future<void> fetchReportReason(BuildContext context) async {
    try {
      await CommonApiHelper.shared.callReportReasonApi(context, (reasonList) {
        reportReasonList = reasonList;
      }, () {}, false);
      notifyListeners();
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  // Submit reson...
  Future<void> blockAndReportUser(
      BuildContext context, int userId, int reasonId, String comment) async {
    try {
      Map<String, dynamic> block = {
        "blockUser": userId,
        "reasonId": reasonId,
        "comment": comment
      };
      print(block);
      await CommonApiHelper.shared.callReportReasonSubmitApi(
        context,
        block,
        () {},
        () {},
      );
      notifyListeners();
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  List<BlockListModel> _blockList = [];
  List<BlockListModel> get blockList => this._blockList;

  set blockList(List<BlockListModel> value) => this._blockList = value;

  Future<void> getBlockList(int page, BuildContext context) async {
    try {
      Map<String, dynamic> _parms = {
        "page": page,
        "pageSize": 10,
      };

      if (page == 1) {
        NetworkClient.getInstance.showLoader(context);
      }

      await NetworkClient.getInstance.callApi(
        context: context,
        params: _parms,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.blockList,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (page == 1) {
            NetworkClient.getInstance.hideProgressDialog();
          }

          if (response["rows"] != null) {
            List<BlockListModel> arrList =
                blockListModelFromJson(jsonEncode(response["rows"]));
            if (page == 1) {
              blockList = arrList;
            } else {
              blockList.addAll(arrList);
            }
          }
          notifyListeners();
        },
        failureCallback: (code, message) {
          NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      NetworkClient.getInstance.hideProgressDialog();
      View.showMessage(context, e.toString());
    }
  }

  Future<void> unBlockUser(int userId, BuildContext context) async {
    try {
      Map<String, dynamic> _parms = {
        "user_id": userId.toString(),
      };

      NetworkClient.getInstance.showLoader(context);
      await NetworkClient.getInstance.callApi(
        context: context,
        params: _parms,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.unBlockUser,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        successCallback: (response, message) {
          NetworkClient.getInstance.hideProgressDialog();
          blockList.removeWhere((element) => element.user.id == userId);
          notifyListeners();
        },
        failureCallback: (code, message) {
          NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      NetworkClient.getInstance.hideProgressDialog();
      View.showMessage(context, e.toString());
    }
  }
}
