import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';

class MatchingProfileProvider with ChangeNotifier {
  List<MatchProfileModel> _matchProfileList = [];

  set matchProfileList(List<MatchProfileModel> matchProfileList) {
    _matchProfileList = matchProfileList;
    notifyListeners();
  }

  List<MatchProfileModel> get matchProfileList => _matchProfileList;

  // Fetch match profile list...
  Future<void> fetchMatchProfileList(BuildContext context,
      {int pageNumber = 1, bool isbackgroundCall = false}) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.userId;
      Map<String, dynamic> _parms = {
        "page": pageNumber,
        "size": 20,
        "userid": userId
      };
      await CommonApiHelper.shared.callMatchProfileListApi(context, _parms,
          (matchProfile) {
        if (pageNumber == 1) {
          matchProfileList = matchProfile;
        } else {
          matchProfileList.addAll(matchProfile);
        }
      }, () {}, isbackgroundCall);
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }
}
