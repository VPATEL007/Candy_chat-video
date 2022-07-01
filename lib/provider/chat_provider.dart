import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/components/Model/Chat/ChatList.dart';
import 'package:video_chat/components/Model/Chat/videoChatHistoryModel.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';

import '../components/Model/Chat/chat_message_model.dart';

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

  List<ChatListData> _chatList = [];

  List<ChatListData> get chatList => this._chatList;

  set chatList(List<ChatListData> value) => this._chatList = value;

  List<VideoChatHistoryResult> _videoChatList = [];

  List<VideoChatHistoryResult> get videoChatList => this._videoChatList;

  set videoChatList(List<VideoChatHistoryResult> value) =>
      this._videoChatList = value;

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
        command: ApiConstants.friendList,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (page == 1) {
            NetworkClient.getInstance.hideProgressDialog();
          }

          if (response != null) {
            List<ChatListData> arrList =
                chatListModelFromJson(jsonEncode(response));
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

  Future<void> getVideoChatHistory(BuildContext context, {page = 1}) async {
    Map<String, dynamic> _parms = {
      "page": page,
      "pageSize": 10,
    };

    // if (page == 1) {
    //   NetworkClient.getInstance.showLoader(context);
    // }

    await NetworkClient.getInstance.callApi(
      context: context,
      params: _parms,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.videoChatHistory,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) {
        // if (page == 1) {
        //   NetworkClient.getInstance.hideProgressDialog();
        // }
        print('response==> $response');
        if (response != null) {
          print('inside response==> ${response['result']}');

          List<VideoChatHistoryResult>? arrList =
              videoChatHistoryModel(jsonEncode(response['result']));
          if (page == 1) {
            videoChatList = arrList;
          } else {
            videoChatList.addAll(arrList);
          }
        }
        notifyListeners();
      },
      failureCallback: (code, message) {
        print('message==> $message');
        // NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  Future<String?> getChatQuesryId(
      BuildContext context, String endDate) async {
    Map<String, dynamic> _parms = {"limit": 10, "order": "desc"};
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
      failureCallback: (code, message) {
        print("sdfsdfsf");
      },
    );

    return query;
  }

  List<ChatMessageData> _chatMessage = [];

  List<ChatMessageData> get chatMessage => this._chatMessage;

  set chatMessage(List<ChatMessageData> value) =>
      this._chatMessage = value;

  Future<void> getChatMessageHistory(
      BuildContext context, String endDate, userId) async {
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.getById+'/$userId',
      headers: getAuthHeaders(),
      method: MethodType.Get,
      successCallback: (response, message) {
        if (response != null) {
          List<ChatMessageData> arrList =
          chatMessageHistoryModel(jsonEncode(response));
          chatMessage = arrList;
          // chatMessage.reversed;
        }
        notifyListeners();
      },
      failureCallback: (code, message) {
        print('message==> $message');
        // NetworkClient.getInstance.hideProgressDialog();
      },
    );
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
