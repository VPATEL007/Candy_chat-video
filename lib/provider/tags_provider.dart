import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Feedback/UserFeedbackModel.dart';
import 'package:video_chat/components/Model/User/tags_model.dart';

class TagsProvider with ChangeNotifier {
  List<TagsModel> _tagsList = [];
  List<TagsModel> get tagsList => this._tagsList;

  set tagsList(List<TagsModel> value) => this._tagsList = value;

  // Fetch tags...
  Future<void> fetchTags(BuildContext context, int userId) async {
    tagsList = [];
    if (userId != 0) await fetchUserFeedBacks(userId);

    try {
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.fetchTags,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (response["rows"] != null) {
            tagsList = tagsModelFromJson(jsonEncode(response["rows"]));
          }

          notifyListeners();
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  // Submit tags...
  Future<void> submitTags(
      BuildContext context, List<String> tags, int userId) async {
    try {
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.setFeedback,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Post,
        params: {"tags": tags, "id": userId},
        successCallback: (response, message) {
          View.showMessage(context, message, mode: DisplayMode.SUCCESS);
        },
        failureCallback: (code, message) {
          View.showMessage(context, message);
        },
      );
    } catch (e) {
      View.showMessage(context, e.toString());
    }
  }

  List<UserFeedbackModel> _userFeedBack = [];

  List<UserFeedbackModel> get userFeedBack => this._userFeedBack;

  set userFeedBack(List<UserFeedbackModel> value) => this._userFeedBack = value;

  // Fetch Gived feedbacks...
  Future<void> fetchUserFeedBacks(int userId) async {
    try {
      Map<String, dynamic> req = {
        "user_id": userId,
      };
      await NetworkClient.getInstance.callApi(
        context: navigationKey.currentContext!,
        params: req,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.userFeedBack,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          if (response != null) {
            userFeedBack = userFeedBackModelFromJson(jsonEncode(response));
          }
        },
        failureCallback: (code, message) {},
      );
    } catch (e) {}
  }

  bool checkFeedBackTagExist(int tagId) {
    if (userFeedBack == null) return false;

    for (var item in userFeedBack) {
      if (item.tagId == tagId) {
        return true;
      }
    }

    return false;
  }
}
