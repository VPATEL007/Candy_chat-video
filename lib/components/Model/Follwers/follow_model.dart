// To parse this JSON data, do
//
//     final followesModel = followesModelFromJson(jsonString);

import 'dart:convert';

List<FollowesModel> followesModelFromJson(String str) =>
    List<FollowesModel>.from(
        jsonDecode(str).map((e) => FollowesModel.fromJson(e)));

String followesModelToJson(FollowesModel data) => json.encode(data.toJson());

class FollowesModel {
  FollowesModel({
    this.id,
    this.user,
  });

  int id;
  User user;

  factory FollowesModel.fromJson(Map<String, dynamic> json) => FollowesModel(
        id: json["id"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
      };
}

class User {
  User({this.providerDisplayName, this.photoUrl, this.id, this.country});

  String providerDisplayName;
  String photoUrl, country;
  int id;

  factory User.fromJson(Map<String, dynamic> json) => User(
      providerDisplayName: json["provider_display_name"],
      photoUrl: json["photo_url"],
      id: json["id"],
      country: json["country"]);

  Map<String, dynamic> toJson() => {
        "provider_display_name": providerDisplayName,
        "photo_url": photoUrl,
        "id": id,
        "country": country
      };
}
