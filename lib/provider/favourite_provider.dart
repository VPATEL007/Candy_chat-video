import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Favourite/FavouriteListModel.dart';

class FavouriteProvider with ChangeNotifier {
  List<FavouriteListModel> _favouriteList = [];
  List<FavouriteListModel> get favouriteList => this._favouriteList;

  set favouriteList(List<FavouriteListModel> value) =>
      this._favouriteList = value;

  Future<void> getFavouriteList(BuildContext context) async {
    try {
      // Map<String, dynamic> _parms = {
      //   "page": page,
      //   "pageSize": 10,
      // };

      // if (page == 1) {
      NetworkClient.getInstance.showLoader(context);
      // }

      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.favouriteList,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          NetworkClient.getInstance.hideProgressDialog();

          if (response != null) {
            List<FavouriteListModel> arrList =
                favouriteListModelFromJson(jsonEncode(response));

            favouriteList = arrList;
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
