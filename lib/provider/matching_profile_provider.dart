import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';

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
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
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
        notifyListeners();
      }, () {}, isbackgroundCall);
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  Future<VideoCallModel> startVideoCall(BuildContext context, int id) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "to_user_id": id,
        "from_user_id": userId,
        "influencer_id": id
      };
      VideoCallModel videoCallModel;
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.startVideoCall,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        params: _parms,
        successCallback: (response, message) {
          videoCallModel = videoCallModelFromJson(jsonEncode(response));
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );

      return videoCallModel;
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  // Left or right swipe...
  Future<void> leftAndRightSwipe(
      BuildContext context, SwipeType swipeType) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "userid": userId,
      };
      if (swipeType != null)
        await NetworkClient.getInstance.callApi(
          context: context,
          baseUrl: ApiConstants.apiUrl,
          command: describeEnum(swipeType).toLowerCase() + "-swipe",
          headers: NetworkClient.getInstance.getAuthHeaders(),
          method: MethodType.Post,
          params: _parms,
          successCallback: (response, message) {},
          failureCallback: (code, message) {
            View.showMessage(context, message);
          },
        );
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }
}

enum SwipeType { Left, Right, None }
