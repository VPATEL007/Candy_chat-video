import 'dart:convert';

import 'package:video_chat/app/utils/date_utils.dart';
import 'package:video_chat/components/Model/message_obj.dart';

ChatObj chatFromJson(String str) => ChatObj.fromJson(json.decode(str));

String chatToJson(ChatObj data) => json.encode(data.toJson());

class ChatObj {
  static String _kChatDate = "ChatDate";
  static String _kChatMessages = "ChatMessages";
  ChatObj({
    this.chatDate,
    this.messageObjList,
  });

  DateTime? chatDate;
  List<MessageObj>? messageObjList;

  factory ChatObj.fromJson(Map<String, dynamic> json) => ChatObj(
        chatDate: json[_kChatDate] ?? "",
        messageObjList: json[_kChatMessages] == null
            ? []
            : List<MessageObj>.from(
                json[_kChatMessages].map((x) => MessageObj.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        _kChatDate: chatDate,
        _kChatMessages:
            List<dynamic>.from(messageObjList!.map((x) => x.toJson())),
      };

  // Get chating dates...
  String get getChatingDates =>
      DateUtilities().getFormattedDay(chatDate ?? DateTime.now());
}
