import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/payment_history_model.dart';

class PaymentHistoryProvider with ChangeNotifier {
  List<PaymentHistoryModel> _paymentHistory = [];
  List<PaymentHistoryModel> get paymentHistory => this._paymentHistory;

  set paymentHistory(List<PaymentHistoryModel> value) =>
      this._paymentHistory = value;

  // Fetch payment history...
  Future<void> fetchPaymentHistory(BuildContext context, String date,
      {bool fetchInBackground = false, int pageNumber = 1}) async {
    Map<String, dynamic> _parms = {
      "page": pageNumber,
      "pageSize": 20,
      "date": date
    };
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.paymentHistory,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["rows"]);
        if (response["rows"] != null) {
          List<PaymentHistoryModel> arrList =
              paymentHistoryModelFromJson(jsonEncode(response["rows"]));
          if (pageNumber == 1) {
            paymentHistory = arrList;
          } else {
            paymentHistory.addAll(arrList);
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
