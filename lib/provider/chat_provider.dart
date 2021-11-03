import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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
      int? userId = app.resolve<PrefUtils>().getUserDetails()?.id;
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
  Future<UserModel?> getUserProfile(int userId, BuildContext context) async {
    UserModel? model;
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
            model?.userImages = List<UserImage>.from(
                response["image_url"].map((x) => UserImage.fromJson(x)));
          }
          notifyListeners();
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

  Future<String?> getChatQuesryId(
      BuildContext context, String channelId, String endDate) async {
    Map<String, dynamic> _parms = {"limit": 10, "order": "desc"};
    Map<String, dynamic> _filter = {
      "destination": channelId,
      "start_time":
          DateTime.now().subtract(Duration(days: 6)).toUtc().toIso8601String(),
      "end_time": endDate
      // "end_time": DateTime.now().toUtc().toIso8601String()
    };
    _parms["filter"] = _filter;

    String? query;

    await NetworkClient.getInstance.callApi(
      context: context,
      params: _parms,
      baseUrl:
          "https://api.agora.io/dev/v2/project/$AGORA_APPID/rtm/message/history/query",
      command: "",
      headers: getAuthHeaders(),
      method: MethodType.Post,
      isAgora: true,
      successCallback: (response, message) {
        if (response != null) {
          query = response["location"].toString().split("/").last;
        }
      },
      failureCallback: (code, message) {},
    );

    return query;
  }

  Future<List<MessageObj>> getChatMessageHistory(
      BuildContext context, String channelId, String endDate) async {
    String? query = await getChatQuesryId(context, channelId, endDate);

    if (query == null) {
      return [];
    }

    List<MessageObj> messages = [];
    String? userId = app.resolve<PrefUtils>().getUserDetails()?.id.toString();

    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl:
          "https://api.agora.io/dev/v2/project/$AGORA_APPID/rtm/message/history/query/$query",
      command: "",
      headers: getAuthHeaders(),
      method: MethodType.Get,
      isAgora: true,
      successCallback: (response, message) {
        if (response is List<dynamic>) {
          for (var item in response) {
            MessageObj message = MessageObj();
            message.message = item["payload"].toString();
            message.sendBy = item["src"].toString();
            message.isSendByMe = userId == message.sendBy;

            DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(item["ms"]).toLocal();
            message.chatDate = dateTime;
            messages.add(message);
          }
        }
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
      },
    );

    return messages.reversed.toList();
  }

  Map<String, dynamic> getAuthHeaders() {
    Map<String, dynamic> authHeaders = Map<String, dynamic>();

    authHeaders["Accept"] = "application/json";
    authHeaders["api_secret"] = AGORA_SECRET;
    authHeaders["x-agora-uid"] =
        app.resolve<PrefUtils>().getUserDetails()?.id.toString();
    authHeaders["x-agora-token"] = AgoraService.instance.RTMToken;

    return authHeaders;
  }
}
