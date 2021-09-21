import 'dart:convert';

import 'package:video_chat/components/Model/User/UserModel.dart';

List<BlockListModel> blockListModelFromJson(String str) =>
    List<BlockListModel>.from(
        jsonDecode(str).map((e) => BlockListModel.fromJson(e)));

class BlockListModel {
  String? commentByUser;
  String? createdOn;
  User? user;

  BlockListModel({this.commentByUser, this.createdOn, this.user});

  BlockListModel.fromJson(Map<String, dynamic> json) {
    commentByUser = json['comment_by_user'];
    createdOn = json['created_on'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_by_user'] = this.commentByUser;
    data['created_on'] = this.createdOn;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    return data;
  }
}

class User {
  String? userName;
  int? id;
  String? photoUrl;
  String? countryIp;
  String? gender;
  List<UserImage>? userImages;

  User(
      {this.userName,
      this.id,
      this.photoUrl,
      this.countryIp,
      this.userImages,
      this.gender});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    id = json['id'];
    photoUrl = json['photo_url'];
    countryIp = json['country_ip'];
    gender = json['gender'];
    if (json['user_images'] != null) {
      userImages = [];
      json['user_images'].forEach((v) {
        userImages?.add(new UserImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['id'] = this.id;
    data['photo_url'] = this.photoUrl;
    data['country_ip'] = this.countryIp;
    data['gender'] = this.gender;
    if (this.userImages != null) {
      data['user_images'] = this.userImages?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
