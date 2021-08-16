import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
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
}
