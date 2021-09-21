import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';

class DiscoverProvider with ChangeNotifier {
  List<MatchProfileModel> _discoverProfileList = [];
  List<MatchProfileModel> get discoverProfileList => this._discoverProfileList;

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

  removeUser(int id) {
    discoverProfileList.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

enum SortBy { General, New, Trending, HighRated }
