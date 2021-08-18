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
  User({
    this.providerDisplayName,
    this.photoUrl,
    this.id,
    this.region,
  });

  String providerDisplayName;
  String photoUrl;
  int id;
  Region region;

  factory User.fromJson(Map<String, dynamic> json) => User(
        providerDisplayName: json["provider_display_name"],
        photoUrl: json["photo_url"],
        id: json["id"],
        region: Region.fromJson(json["region"]),
      );

  Map<String, dynamic> toJson() => {
        "provider_display_name": providerDisplayName,
        "photo_url": photoUrl,
        "id": id,
        "region": region.toJson(),
      };
}

class Region {
  Region({
    this.regionName,
  });

  String regionName;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        regionName: json["region_name"],
      );

  Map<String, dynamic> toJson() => {
        "region_name": regionName,
      };
}
