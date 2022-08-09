
import 'dart:convert';

List<NotificationDataModel> rechargeNotificationModelFromJson(String str) =>
    List<NotificationDataModel>.from(
        jsonDecode(str).map((e) => NotificationDataModel.fromJson(e)));


class RechargeNotificationModel {
  String? status;
  String? message;
  String? messageCode;
  bool? success;
  List<NotificationDataModel>? data;
  int? statusCode;

  RechargeNotificationModel(
      {this.status,
        this.message,
        this.messageCode,
        this.success,
        this.data,
        this.statusCode});

  RechargeNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['messageCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <NotificationDataModel>[];
      json['data'].forEach((v) {
        data!.add(new NotificationDataModel.fromJson(v));
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

class NotificationDataModel {
  int? id;
  String? notification;
  String? status;
  String? createdOn;
  String? type;
  User? user;

  NotificationDataModel({this.id, this.notification, this.status, this.createdOn, this.user});

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notification = json['notification'];
    status = json['status'];
    type = json['type'];
    createdOn = json['created_on'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notification'] = this.notification;
    data['status'] = this.status;
    data['type'] = this.type;
    data['created_on'] = this.createdOn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? userName;
  int? id;
  UserImages? userImages;

  User({this.userName, this.id, this.userImages});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    id = json['id'];
    userImages = json['user_images'] != null
        ? new UserImages.fromJson(json['user_images'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['id'] = this.id;
    if (this.userImages != null) {
      data['user_images'] = this.userImages!.toJson();
    }
    return data;
  }
}

class UserImages {
  int? id;
  String? photoUrl;

  UserImages({this.id, this.photoUrl});

  UserImages.fromJson(Map<String, dynamic> json) {
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

