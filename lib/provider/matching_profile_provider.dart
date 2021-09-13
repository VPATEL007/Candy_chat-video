import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';

import 'followes_provider.dart';

class MatchingProfileProvider with ChangeNotifier {
  List<MatchProfileModel> _matchProfileList = [];
  List<MatchProfileModel> _tempProfileList = [];

  set matchProfileList(List<MatchProfileModel> matchProfileList) {
    _matchProfileList = matchProfileList;
    notifyListeners();
  }

  List<MatchProfileModel> get matchProfileList => _matchProfileList;
  List<MatchProfileModel> get tempMatchProfileList => _tempProfileList;

  // Fetch match profile list...
  Future<void> fetchMatchProfileList(BuildContext context,
      {int pageNumber = 1,
      bool isbackgroundCall = false,
      int language,
      int fromAge,
      int toAge,
      bool isNotAppend}) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {};
      _parms["page"] = pageNumber;
      _parms["size"] = 20;
      _parms["userid"] = userId;
      if (language != null) _parms["langid"] = language;
      if (fromAge != null) _parms["fromage"] = fromAge;
      if (toAge != null) _parms["toage"] = toAge;

      await CommonApiHelper.shared.callMatchProfileListApi(context, _parms,
          (matchProfile) {
        // if (isNotAppend != null && isNotAppend == true) {
        //   matchProfileList = matchProfile;
        // } else {
        _tempProfileList = matchProfile;
        if (pageNumber == 1) {
          matchProfileList = matchProfile;
        } else {
          matchProfileList.addAll(matchProfile);
        }
        // }

        notifyListeners();
      }, () {}, isbackgroundCall);
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  VideoCallModel videoCallModel;
  Future<void> startVideoCall(BuildContext context, int id) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "to_user_id": id,
        "from_user_id": userId,
        "influencer_id": id
      };

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
      notifyListeners();
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  CallStatusModel coinStatus;
  Future<void> receiveVideoCall(
      BuildContext context, String sessionId, String channelName) async {
    try {
      coinStatus = null;
      Map<String, dynamic> _parms = {
        "session_id": sessionId,
        "channel_name": channelName,
      };

      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.receiveVideoCall,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Patch,
        params: _parms,
        successCallback: (response, message) {
          if (response["call_status"] != null) {
            coinStatus = CallStatusModel.fromJson(response["call_status"]);
            notifyListeners();
          }
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  CoinModel coinBalance;
  Future<void> checkCoinBalance(
      BuildContext context, int toUserId, String name) async {
    try {
      var user =
          Provider.of<FollowesProvider>(context, listen: false).userModel;
      Map<String, dynamic> _parms = {
        "from_user_id": user.id,
        "to_user_id": toUserId,
      };

      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.coinBalance,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        params: _parms,
        successCallback: (response, message) {
          if (response != null) {
            if (user.isInfluencer) {
              coinBalance = CoinModel();
              coinBalance.lowBalance = false;
            } else {
              coinBalance = CoinModel.fromJson(response);
              if (coinBalance?.lowBalance == true) {
                View.showMessage(context, "Insufficient coin balance.");
              }
            }
          } else {
            coinBalance = null;
          }

          notifyListeners();
        },
        failureCallback: (code, message) {
          coinBalance = null;
          View.showMessage(context, message + " $name");
        },
      );
    } catch (e) {
      coinBalance = null;
      View.showMessage(context, e.toString());
    }
  }

  // Left or right swipe...
  Future<bool> leftAndRightSwipe(
      BuildContext context, SwipeType swipeType) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "userid": userId,
      };
      bool startCall = false;
      if (swipeType != null)
        await NetworkClient.getInstance.callApi(
          context: context,
          baseUrl: ApiConstants.apiUrl,
          command: describeEnum(swipeType).toLowerCase() + "-swipe",
          headers: NetworkClient.getInstance.getAuthHeaders(),
          method: MethodType.Post,
          params: _parms,
          successCallback: (response, message) {
            startCall = response;
          },
          failureCallback: (code, message) {
            View.showMessage(context, message);
          },
        );
      return startCall;
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }
}

enum SwipeType { Left, Right, None }
