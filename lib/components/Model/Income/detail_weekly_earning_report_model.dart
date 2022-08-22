// To parse this JSON data, do
//
//     final weeklyDetailSalaryModel = weeklyDetailSalaryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<WeeklyDetailDataModel> weeklyDetailSalaryModelFromJson(String str) => List<WeeklyDetailDataModel>.from(
    jsonDecode(str).map((e) => WeeklyDetailDataModel.fromJson(e)));

String weeklyDetailSalaryModelToJson(WeeklyDetailSalaryModel data) => json.encode(data.toJson());

class WeeklyDetailSalaryModel {
  WeeklyDetailSalaryModel({
    required this.status,
    required this.message,
    required this.messageCode,
    required this.success,
    required this.data,
    required this.statusCode,
  }) {
    // TODO: implement
    throw UnimplementedError();
  }

  String status;
  String message;
  String messageCode;
  dynamic success;
  List<WeeklyDetailDataModel> data;
  int statusCode;

  factory WeeklyDetailSalaryModel.fromJson(Map<String, dynamic> json) => WeeklyDetailSalaryModel(
    status: json["status"],
    message: json["message"],
    messageCode: json["messageCode"],
    success: json["success"],
    data: List<WeeklyDetailDataModel>.from(json["data"].map((x) => WeeklyDetailDataModel.fromJson(x))),
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "messageCode": messageCode,
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "statusCode": statusCode,
  };
}

class WeeklyDetailDataModel {
  WeeklyDetailDataModel({
    required this.hostNameId,
    required this.hostName,
    required this.callCoins,
    required this.giftCoins,
    required this.id,
    required this.matchCoins,
    required this.referralCoins,
    required this.albumCoins,
    required this.totalCoins,
    required this.agencyId,
    required this.currency,
    required this.status,
    required this.paymentMode,
    required this.startWeekDate,
    required this.endWeekDate,
  });

  int id;
  int hostNameId;
  String hostName;
  int callCoins;
  int giftCoins;
  int matchCoins;
  int referralCoins;
  int albumCoins;
  int totalCoins;
  int agencyId;
  String currency;
  String status;
  String paymentMode;
  DateTime startWeekDate;
  DateTime endWeekDate;

  factory WeeklyDetailDataModel.fromJson(Map<String, dynamic> json) => WeeklyDetailDataModel(
    id: json["id"],
    hostNameId: json["hostNameId"],
    hostName: json["hostName"],
    callCoins: json["callCoins"],
    giftCoins: json["giftCoins"],
    matchCoins: json["matchCoins"],
    referralCoins: json["referralCoins"],
    albumCoins: json["albumCoins"],
    totalCoins: json["totalCoins"],
    agencyId: json["agencyId"],
    currency: json["currency"],
    status: json["status"],
    paymentMode: json["paymentMode"],
    startWeekDate: DateTime.parse(json["startWeekDate"]),
    endWeekDate: DateTime.parse(json["endWeekDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "hostNameId": hostNameId,
    "hostName": hostName,
    "callCoins": callCoins,
    "giftCoins": giftCoins,
    "matchCoins": matchCoins,
    "referralCoins": referralCoins,
    "albumCoins": albumCoins,
    "totalCoins": totalCoins,
    "agencyId": agencyId,
    "currency": currency,
    "status": status,
    "paymentMode": paymentMode,
    "startWeekDate": startWeekDate.toIso8601String(),
    "endWeekDate": endWeekDate.toIso8601String(),
  };
}
