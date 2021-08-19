// To parse this JSON data, do
//
//     final feedBackModel = feedBackModelFromJson(jsonString);

import 'dart:convert';

List<FeedBackModel> feedBackModelFromJson(String str) =>
    List<FeedBackModel>.from(
        jsonDecode(str).map((e) => FeedBackModel.fromJson(e)));

String feedBackModelToJson(FeedBackModel data) => json.encode(data.toJson());

class FeedBackModel {
  FeedBackModel({
    this.id,
    this.category,
    this.detail,
    this.isActive,
  });

  int id;
  String category;
  String detail;
  bool isActive,isSelected = false;

  factory FeedBackModel.fromJson(Map<String, dynamic> json) => FeedBackModel(
        id: json["id"],
        category: json["category"],
        detail: json["detail"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "detail": detail,
        "is_active": isActive,
      };
}
