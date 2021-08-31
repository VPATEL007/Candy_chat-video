import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Visitor/VisitorModel.dart';

class VisitorProvider with ChangeNotifier {
  //Chat List

  List<VisitorModel> _visitorList = [];
  List<VisitorModel> get visitorList => this._visitorList;

  set visitorList(List<VisitorModel> value) => this._visitorList = value;

  Future<void> getVisitorList(int page, BuildContext context) async {
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
        command: ApiConstants.visitorList,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (page == 1) {
            NetworkClient.getInstance.hideProgressDialog();
          }

          if (response["visiterList"] != null) {
            List<VisitorModel> arrList =
                visitorListModelFromJson(jsonEncode(response["visiterList"]));
            if (page == 1) {
              visitorList = arrList;
            } else {
              visitorList.addAll(arrList);
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
}
