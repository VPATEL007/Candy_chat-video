import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Follwers/follow_model.dart';

class FollowesProvider with ChangeNotifier {
  List<FollowesModel> _followersList = [];
  List<FollowesModel> _followingList = [];

  List<FollowesModel> get followingList => this._followingList;

  set followingList(List<FollowesModel> value) => this._followingList = value;

  List<FollowesModel> get followersList => this._followersList;

  set followersList(List<FollowesModel> value) => this._followersList = value;

  // Fetch followes...
  Future<void> fetchFollowes(BuildContext context,
      {bool fetchInBackground = true, int pageNumber = 1}) async {
    Map<String, dynamic> _parms = {"page": pageNumber};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getFollowes,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["rows"]);
        if (response["rows"] != null) {
          List<FollowesModel> arrList =
              followesModelFromJson(jsonEncode(response["rows"]));
          if (pageNumber == 1) {
            followersList = arrList;
          } else {
            followersList.addAll(arrList);
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

  // Fetch following...
  Future<void> fetchFollowing(BuildContext context,
      {bool fetchInBackground = true, int pageNumber = 1}) async {
    Map<String, dynamic> _parms = {"page": pageNumber};
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getFollowing,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      params: _parms,
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        print(response["rows"]);
        if (response["rows"] != null) {
          List<FollowesModel> arrList =
              followesModelFromJson(jsonEncode(response["rows"]));
          if (pageNumber == 1) {
            followingList = arrList;
          } else {
            followingList.addAll(arrList);
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

  // Unfollow user
  Future<void> unfollowUser(
    BuildContext context,
    int userId, {
    bool fetchInBackground = true,
  }) async {
    _followingList.removeWhere((element) => element?.user?.id == userId);
    if (!fetchInBackground) NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.unFollowUser,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {"userId": userId},
      successCallback: (response, message) async {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
      },
      failureCallback: (code, message) {
        if (!fetchInBackground) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
    notifyListeners();
  }
}
