import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Chat/ChatList.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';

class ChatProvider with ChangeNotifier {
  // Create Chat...
  Future<void> startChat(
      int toUserId, BuildContext context, bool isFromProfile) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
      Map<String, dynamic> _parms = {
        "to_user_id": toUserId,
        "from_user_id": userId,
      };

      NetworkClient.getInstance.showLoader(context);
      await NetworkClient.getInstance.callApi(
        context: context,
        params: _parms,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.createChat,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        successCallback: (response, message) {
          NetworkClient.getInstance.hideProgressDialog();
          if (response["channel_name"] != null) {
            NavigationUtilities.push(Chat(
              channelId: response["channel_name"].toString(),
              toUserId: toUserId,
              isFromProfile: isFromProfile,
            ));
          }
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

  // Get Profile...
  Future<UserModel> getUserProfile(int userId, BuildContext context) async {
    UserModel model;
    try {
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.getProfile + userId.toString(),
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          model = UserModel.fromJson(response);
          if (response["image_url"] != null) {
            model.userImages = List<UserImage>.from(
                response["image_url"].map((x) => UserImage.fromJson(x)));
          }
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );
      return model;
    } catch (e) {
      View.showMessage(context, e.toString());
      return model;
    }
  }

  //Chat List

  List<ChatListModel> _chatList = [];
  List<ChatListModel> get chatList => this._chatList;

  set chatList(List<ChatListModel> value) => this._chatList = value;

  Future<void> getChatList(int page, BuildContext context) async {
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
        command: ApiConstants.chatList,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (page == 1) {
            NetworkClient.getInstance.hideProgressDialog();
          }

          if (response["rows"] != null) {
            List<ChatListModel> arrList =
                chatListModelFromJson(jsonEncode(response["rows"]));
            if (page == 1) {
              chatList = arrList;
            } else {
              chatList.addAll(arrList);
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

  Future<void> getChatHistory(BuildContext context) async {
    Map<String, dynamic> _parms = {"offset": 100, "limit": 10, "order": "asc"};
    Map<String, dynamic> _filter = {
      "destination": "81-91",
      "start_time": "2021-04-03 10:29:32.300806Z",
      "end_time": DateTime.now().toUtc().toString()
    };
    _parms["filter"] = _filter;

    await NetworkClient.getInstance.callApi(
      context: context,
      params: _parms,
      baseUrl:
          "https://api.agora.io/dev/v2/project/a8a459f76c8e48dc85adb554bb94d8b8/rtm/message/history/query",
      command: "",
      headers: getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) {},
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  Future<void> getChatMessageHistory(BuildContext context) async {
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl:
          "https://api.agora.io/dev/v2/project/a8a459f76c8e48dc85adb554bb94d8b8/rtm/message/history/query/MjIzMDA2OjY4MjI0NzAx",
      command: "",
      headers: getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) {},
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  Map<String, dynamic> getAuthHeaders() {
    Map<String, dynamic> authHeaders = Map<String, dynamic>();

    authHeaders["Accept"] = "application/json";
    authHeaders["api_secret"] = "05c158b57a604bf2a694f83e0f93296e";
    authHeaders["x-agora-uid"] = "91";
    authHeaders["x-agora-token"] =
        "006a8a459f76c8e48dc85adb554bb94d8b8IABdgnOUgx3w870drOXEzKQ9RoJ1asnWlgHhy4JTNJ7V53+fgx4AAAAAEAAURg0wy0gzYQEA6ANbBTJh";

    return authHeaders;
  }
}
