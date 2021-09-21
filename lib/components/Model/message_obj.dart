import 'dart:convert';

import 'package:intl/intl.dart';

List<MessageObj> messageObjListFromJson(List<Map<String, dynamic>> str) =>
    List<MessageObj>.from(str.map((x) => MessageObj.fromJson(x)));

MessageObj messageObjFromJson(String str) =>
    MessageObj.fromJson(json.decode(str));

String messageObjToJson(MessageObj data) => json.encode(data.toJson());

class MessageObj {
  String? toSend;
  String? sendBy;
  String? message;
  int? type;
  DateTime? chatDate;

  bool isSendByMe;

  MessageObj(
      {this.toSend,
      this.sendBy,
      this.message,
      this.type,
      this.chatDate,
      this.isSendByMe = true});

  factory MessageObj.fromJson(Map<String, dynamic> json) => MessageObj(
        toSend: json["toSend"] ?? "",
        sendBy: json["sendBy"] ?? "",
        message: json["message"] ?? "",
        type: json["type"],
        chatDate: json["chatDate"] ?? "",
      );
  Map<String, dynamic> toJson() => {
        "toSend": toSend ?? "",
        "sendBy": sendBy ?? "",
        "message": message ?? "",
        "type": type,
        "chatDate": chatDate ?? "",
      };

  String get getChatDate =>
      DateFormat("hh:mm a").format(chatDate ?? DateTime.now());
}
