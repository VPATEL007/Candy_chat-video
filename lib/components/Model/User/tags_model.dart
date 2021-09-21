// To parse this JSON data, do
//
//     final tagsModel = tagsModelFromJson(jsonString);

import 'dart:convert';

List<TagsModel> tagsModelFromJson(String str) =>
    List<TagsModel>.from(jsonDecode(str).map((e) => TagsModel.fromJson(e)));

String tagsModelToJson(TagsModel data) => json.encode(data.toJson());

class TagsModel {
  TagsModel({
    this.id,
    this.tag,
    this.isActive,
  });

  int? id;
  String? tag;
  bool? isActive;

  factory TagsModel.fromJson(Map<String, dynamic> json) => TagsModel(
        id: json["id"],
        tag: json["tag"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "is_active": isActive,
      };
}
