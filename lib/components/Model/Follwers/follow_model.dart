// To parse this JSON data, do
//
//     final followesModel = followesModelFromJson(jsonString);

import 'dart:convert';

List<FollowesModel> followesModelFromJson(String str) =>
    List<FollowesModel>.from(
        jsonDecode(str).map((e) => FollowesModel.fromJson(e)));

String followesModelToJson(FollowesModel data) => json.encode(data.toJson());

class FollowesModel {
  String? createdOn;
  ByUser? byUser;

  FollowesModel({this.createdOn, this.byUser});

  FollowesModel.fromJson(Map<String, dynamic> json) {
    createdOn = json['created_on'];
    byUser = json['user'] != null ? new ByUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_on'] = this.createdOn;
    if (this.byUser != null) {
      data['user'] = this.byUser?.toJson();
    }
    return data;
  }
}

class ByUser {
  String? providerDisplayName;
  String? photoUrl;
  int? id;
  String? gender;
  String? countryIp;
  Region? region;
  List<UserImages>? userImages;
  bool? callProbability;
  bool? isLike;

  ByUser(
      {this.providerDisplayName,
      this.photoUrl,
      this.id,
      this.gender,
      this.region,
      this.userImages,
      this.countryIp, this.callProbability, this.isLike});

  ByUser.fromJson(Map<String, dynamic> json) {
    providerDisplayName = json['user_name'];
    photoUrl = json['photo_url'];
    id = json['id'];
    gender = json['gender'];
    countryIp = json['country_ip'];
    region =
        json['region'] != null ? new Region.fromJson(json['region']) : null;
    if (json['user_images'] != null) {
      userImages = [];
      json['user_images'].forEach((v) {
        userImages?.add(new UserImages.fromJson(v));
      });
    }
    callProbability = json['call_probability'];
    isLike = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.providerDisplayName;
    data['photo_url'] = this.photoUrl;
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['country_ip'] = this.countryIp;
    if (this.region != null) {
      data['region'] = this.region?.toJson();
    }
    if (this.userImages != null) {
      data['user_images'] = this.userImages?.map((v) => v.toJson()).toList();
    }
    data['call_probability'] = this.callProbability;
    data['liked'] = this.isLike;
    return data;
  }
}

class Region {
  String? regionName;

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
  int? id;
  String? photoUrl;

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
