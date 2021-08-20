import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/User/tags_model.dart';

class TagsProvider with ChangeNotifier {
  List<TagsModel> _tagsList = [];
  List<TagsModel> get tagsList => this._tagsList;

  set tagsList(List<TagsModel> value) => this._tagsList = value;

  // Fetch tags...
  Future<void> fetchTags(BuildContext context) async {
    try {
      await NetworkClient.getInstance.callApi(
        context: context,
        baseUrl: ApiConstants.apiUrl,
        command: ApiConstants.fetchTags,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        method: MethodType.Get,
        successCallback: (response, message) {
          tagsList = tagsModelFromJson(jsonEncode(response));
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
  Future<void> submitTags(BuildContext context, List<String> tags) async {
    try {
      int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
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
}
