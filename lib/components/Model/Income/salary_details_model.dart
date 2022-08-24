// To parse this JSON data, do
//
//     final salaryDetailModel = salaryDetailModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SalaryDetailModel salaryDetailModelFromJson(String str) => SalaryDetailModel.fromJson(json.decode(str));

String salaryDetailModelToJson(SalaryDetailModel data) => json.encode(data.toJson());

class SalaryDetailModel {
  SalaryDetailModel({
    required this.userLevel,
    required this.currecy,
    required this.coinValue,
    required this.currencyValue,
  });

  String userLevel;
  String currecy;
  int coinValue;
  int currencyValue;

  factory SalaryDetailModel.fromJson(Map<String, dynamic> json) => SalaryDetailModel(
    userLevel: json["user_level"],
    currecy: json["currecy"],
    coinValue: json["coin_value"],
    currencyValue: json["currency_value"],
  );

  Map<String, dynamic> toJson() => {
    "user_level": userLevel,
    "currecy": currecy,
    "coin_value": coinValue,
    "currency_value": currencyValue,
  };
}
