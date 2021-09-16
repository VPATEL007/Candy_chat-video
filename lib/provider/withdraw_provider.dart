import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Payment/WithDrawRequestList.dart';
import 'package:video_chat/components/Model/Payment/paymentMethodModel.dart';

class WithDrawProvider with ChangeNotifier {
  List<PaymentMethodModel> _paymentMethod = [];
  List<PaymentMethodModel> get paymentMethod => this._paymentMethod;

  set paymentMethod(List<PaymentMethodModel> value) =>
      this._paymentMethod = value;

  getPaymentMethod(BuildContext context) async {
    try {
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.paymentMethod,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (response != null) {
            paymentMethod = paymentMethodModelFromJson(jsonEncode(response));
          }

          notifyListeners();
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  List<WithDrawListModel> _withDrawList = [];
  List<WithDrawListModel> get withDrawList => this._withDrawList;

  set withDrawList(List<WithDrawListModel> value) => this._withDrawList = value;

  getWithDrawRequest(int page, String date, BuildContext context) async {
    Map<String, dynamic> parms = {"page": page, "size": 20};
    try {
      if (page == 1) NetworkClient.getInstance.showLoader(context);
      await NetworkClient.getInstance.callApi(
        params: parms,
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.withDrawRequestList,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (page == 1) NetworkClient.getInstance.hideProgressDialog();
          if (response["rows"] != null) {
            List<WithDrawListModel> arrList =
                withDrawListModelFromJson(jsonEncode(response["rows"]));
            if (page == 1) {
              withDrawList = arrList;
            } else {
              withDrawList.addAll(arrList);
            }
          }

          notifyListeners();
        },
        failureCallback: (code, message) {
          if (page == 1) NetworkClient.getInstance.hideProgressDialog();
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      if (page == 1) NetworkClient.getInstance.hideProgressDialog();
      View.showMessage(context, e.toString());
    }
  }
}
