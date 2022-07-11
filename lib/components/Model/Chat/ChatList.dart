import 'dart:convert';

import 'package:video_chat/app/utils/pref_utils.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/main.dart';

List<ChatListData> chatListModelFromJson(String str) => List<ChatListData>.from(
    jsonDecode(str).map((e) => ChatListData.fromJson(e)));

class ChatListModel {
  String? status;
  String? message;
  String? messageCode;
  bool? success;
  List<ChatListData>? data;
  int? statusCode;

  ChatListModel(
      {this.status,
      this.message,
      this.messageCode,
      this.success,
      this.data,
      this.statusCode});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['messageCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <ChatListData>[];
      json['data'].forEach((v) {
        data!.add(new ChatListData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['messageCode'] = this.messageCode;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class ChatListData {
  int? id;
  int? isSeen;
  String? message;
  String? createdOn;
  String? updatedOn;
  String? giftUrl;
  ChatListUser? user;
  List<ChatListUserImages>? userImages;

  ChatListData(
      {this.id,
      this.isSeen,
      this.message,
      this.createdOn,
      this.user,
      this.updatedOn,
      this.userImages,
      this.giftUrl});

  ChatListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSeen = json['isSeen'];
    message = json['message'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    user =
        json['user'] != null ? new ChatListUser.fromJson(json['user']) : null;
    if (json['user_images'] != null) {
      userImages = <ChatListUserImages>[];
      json['user_images'].forEach((v) {
        userImages!.add(new ChatListUserImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isSeen'] = this.isSeen;
    data['message'] = this.message;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userImages != null) {
      data['user_images'] = this.userImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatListUser {
  int? id;
  String? userName;
  String? onlineStatus;
  String? photoUrl;

  ChatListUser({this.id, this.userName, this.onlineStatus, this.photoUrl});

  ChatListUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    onlineStatus = json['online_status'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['online_status'] = this.onlineStatus;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}

class ChatListUserImages {
  int? id;
  String? photoUrl;

  ChatListUserImages({this.id, this.photoUrl});

  ChatListUserImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}
