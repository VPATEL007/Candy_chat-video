import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';

class DiscoverProvider with ChangeNotifier {
  List<MatchProfileModel> _discoverProfileList = [];

  List<MatchProfileModel> get discoverProfileList => this._discoverProfileList;
  String userStatus = 'online';

  set discoverProfileList(List<MatchProfileModel> value) =>
      this._discoverProfileList = value;

  // Fetch discover profile list...
  Future<void> fetchDiscoverProfileList(BuildContext context, SortBy sortBy,
      {int pageNumber = 1, bool isbackgroundCall = true}) async {
    try {
      int? userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "page": pageNumber,
        "size": 20,
        "userid": userId,
        "sortby": sortBy == SortBy.HighRated
            ? "high-rated"
            : describeEnum(sortBy).toString().toLowerCase()
      };
      await CommonApiHelper.shared.callMatchProfileListApi(context, _parms,
          (matchProfile) {
        if (pageNumber == 1) {
          discoverProfileList = matchProfile;
        } else {
          discoverProfileList.addAll(matchProfile);
        }
        notifyListeners();
      }, () {}, isbackgroundCall);
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  Future<void> setUserStatus(context, status) async {
    Map<String, dynamic> params = {"online_status": status};
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.setUserStatus,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: params,
      successCallback: (response, message) async {
        userStatus = status;
        notifyListeners();
        if (status == 'online') {
          View.showMessage(
              context, 'You are now online and receive calls from users',
              mode: DisplayMode.SUCCESS);
        } else {
          View.showMessage(context, 'You are now offline',
              mode: DisplayMode.SUCCESS);
        }
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
  }

  updateStatus(status) {
    userStatus = status;
    notifyListeners();
  }

  Future<void> getUserStatus(context) async {
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getUserStatus,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) async {
        userStatus = response['online_status'];
        notifyListeners();
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
  }

  removeUser(int id) {
    discoverProfileList.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

enum SortBy { General, New, Trending, HighRated }
