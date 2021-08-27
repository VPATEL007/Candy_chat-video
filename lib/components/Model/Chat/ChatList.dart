import 'dart:convert';

import 'package:video_chat/app/utils/pref_utils.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/main.dart';

List<ChatListModel> chatListModelFromJson(String str) =>
    List<ChatListModel>.from(
        jsonDecode(str).map((e) => ChatListModel.fromJson(e)));

class ChatListModel {
  int id;
  int user1;
  int user2;
  String channelName;
  String updatedOn;
  String createdOn;
  WithUser withUser;

  ChatListModel(
      {this.id,
      this.user1,
      this.user2,
      this.channelName,
      this.updatedOn,
      this.createdOn,
      this.withUser});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user1 = json['user1'];
    user2 = json['user2'];
    channelName = json['channel_name'];
    updatedOn = json['updated_on'];
    createdOn = json['created_on'];
    withUser = json['withUser'] != null
        ? new WithUser.fromJson(json['withUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user1'] = this.user1;
    data['user2'] = this.user2;
    data['channel_name'] = this.channelName;
    data['updated_on'] = this.updatedOn;
    data['created_on'] = this.createdOn;
    if (this.withUser != null) {
      data['withUser'] = this.withUser.toJson();
    }
    return data;
  }

  int getToUserId() {
    int userId = app.resolve<PrefUtils>().getUserDetails()?.id;
    if (userId == user1) {
      return user2;
    }
    return user1;
  }
}

class WithUser {
  int id;
  String userName;
  List<UserImage> userImages;

  WithUser({this.id, this.userName, this.userImages});

  WithUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    if (json['user_images'] != null) {
      userImages = [];
      json['user_images'].forEach((v) {
        userImages.add(new UserImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    if (this.userImages != null) {
      data['user_images'] = this.userImages.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getUserImage() {
    if (userImages.length > 0) {
      return userImages?.first?.photoUrl ?? "";
    }
    return "";
  }
}
