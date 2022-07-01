import 'dart:convert';

  List<ChatMessageData> chatMessageHistoryModel(String str) =>
    List<ChatMessageData>.from(
        jsonDecode(str).map((e) => ChatMessageData.fromJson(e)));

class ChatMessageModel {
  String? status;
  String? message;
  String? messageCode;
  bool? success;
  List<ChatMessageData>? data;
  int? statusCode;

  ChatMessageModel(
      {this.status,
        this.message,
        this.messageCode,
        this.success,
        this.data,
        this.statusCode});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['messageCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <ChatMessageData>[];
      json['data'].forEach((v) {
        data!.add(new ChatMessageData.fromJson(v));
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

class ChatMessageData {
  int? id;
  int? toSend;
  int? sendBy;
  String? message;
  int? type;
  String? chatDate;
  String? giftUlr;
  bool isSendByMe = false;
  int? status;
  String? createdOn;
  String? updatedOn;

  ChatMessageData(
      {this.id,
        this.toSend,
        this.sendBy,
        this.message,
        this.type,
        this.chatDate,
        this.giftUlr,
        this.isSendByMe= false,
        this.status,
        this.createdOn,
        this.updatedOn});

  ChatMessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toSend = json['toSend'];
    sendBy = json['sendBy'];
    message = json['message'];
    type = json['type'];
    chatDate = json['chatDate'];
    giftUlr = json['giftUlr'];
    status = json['status'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['toSend'] = this.toSend;
    data['sendBy'] = this.sendBy;
    data['message'] = this.message;
    data['type'] = this.type;
    data['chatDate'] = this.chatDate;
    data['giftUlr'] = this.giftUlr;
    data['status'] = this.status;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
  bool isGiftMessage() {
    if (message?.contains("isGift") == true) {
      var split = message?.split("~");
      if (split?.length == 2) {
        giftUlr = split?.last;
        return true;
      }
    }
    return false;
  }
}