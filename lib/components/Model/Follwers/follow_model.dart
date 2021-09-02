// To parse this JSON data, do
//
//     final followesModel = followesModelFromJson(jsonString);

import 'dart:convert';

List<FollowesModel> followesModelFromJson(String str) =>
    List<FollowesModel>.from(
        jsonDecode(str).map((e) => FollowesModel.fromJson(e)));

String followesModelToJson(FollowesModel data) => json.encode(data.toJson());

class FollowesModel {
  String createdOn;
  ByUser byUser;

  FollowesModel({this.createdOn, this.byUser});

  FollowesModel.fromJson(Map<String, dynamic> json) {
    createdOn = json['created_on'];
    byUser = json['user'] != null ? new ByUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_on'] = this.createdOn;
    if (this.byUser != null) {
      data['user'] = this.byUser.toJson();
    }
    return data;
  }
}

class ByUser {
  String providerDisplayName;
  String photoUrl;
  int id;
  String gender;
  Region region;
  List<UserImages> userImages;

  ByUser(
      {this.providerDisplayName,
      this.photoUrl,
      this.id,
      this.gender,
      this.region,
      this.userImages});

  ByUser.fromJson(Map<String, dynamic> json) {
    providerDisplayName = json['provider_display_name'];
    photoUrl = json['photo_url'];
    id = json['id'];
    gender = json['gender'];
    region =
        json['region'] != null ? new Region.fromJson(json['region']) : null;
    if (json['user_images'] != null) {
      userImages = new List<UserImages>();
      json['user_images'].forEach((v) {
        userImages.add(new UserImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider_display_name'] = this.providerDisplayName;
    data['photo_url'] = this.photoUrl;
    data['id'] = this.id;
    data['gender'] = this.gender;
    if (this.region != null) {
      data['region'] = this.region.toJson();
    }
    if (this.userImages != null) {
      data['user_images'] = this.userImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Region {
  String regionName;

  Region({this.regionName});

  Region.fromJson(Map<String, dynamic> json) {
    regionName = json['region_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region_name'] = this.regionName;
    return data;
  }
}

class UserImages {
  int id;
  String photoUrl;

  UserImages({this.id, this.photoUrl});

  UserImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}
