import 'dart:convert';

List<VideoChatHistoryResult> videoChatHistoryModel(String str) =>
    List<VideoChatHistoryResult>.from(
        jsonDecode(str).map((e) => VideoChatHistoryResult.fromJson(e)));

class VideoChatHistoryModel {
  String? status;
  String? message;
  String? messageCode;
  bool? success;
  VideoChatHistoryData? data;
  int? statusCode;

  VideoChatHistoryModel(
      {this.status,
        this.message,
        this.messageCode,
        this.success,
        this.data,
        this.statusCode});

  VideoChatHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['messageCode'];
    success = json['success'];
    data = json['data'] != null ? new VideoChatHistoryData.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['messageCode'] = this.messageCode;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class VideoChatHistoryData {
  List<VideoChatHistoryResult>? result;

  VideoChatHistoryData({this.result});

  VideoChatHistoryData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <VideoChatHistoryResult>[];
      json['result'].forEach((v) {
        result!.add(new VideoChatHistoryResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoChatHistoryResult {
  int? id;
  int? toUserId;
  String? photoUrl;
  String? userName;
  String? onlineStatus;
  int? callDurationMins;
  String? startedOn;
  String? gender;

  VideoChatHistoryResult(
      {this.id,
        this.toUserId,
        this.photoUrl,
        this.userName,
        this.onlineStatus,
        this.callDurationMins,
        this.startedOn,
        this.gender});

  VideoChatHistoryResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUserId = json['to_user_id'];
    photoUrl = json['photo_url'];
    userName = json['user_name'];
    onlineStatus = json['online_status'];
    callDurationMins = json['call_duration_mins'];
    startedOn = json['started_on'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['to_user_id'] = this.toUserId;
    data['photo_url'] = this.photoUrl;
    data['user_name'] = this.userName;
    data['online_status'] = this.onlineStatus;
    data['call_duration_mins'] = this.callDurationMins;
    data['started_on'] = this.startedOn;
    data['gender'] = this.gender;
    return data;
  }
}

