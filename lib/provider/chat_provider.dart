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
}
