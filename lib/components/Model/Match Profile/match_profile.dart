// To parse this JSON data, do
//
//     final matchProfileModel = matchProfileModelFromJson(jsonString);

import 'dart:convert';

List<MatchProfileModel> matchProfileModelFromJson(String str) =>
    List<MatchProfileModel>.from(
        jsonDecode(str).map((e) => MatchProfileModel.fromJson(e)));

String matchProfileModelToJson(MatchProfileModel data) =>
    json.encode(data.toJson());

class MatchProfileModel {
  MatchProfileModel(
      {this.id,
      this.age,
      this.providerDisplayName,
      this.imageUrl,
      this.userName,
      this.gender,
      this.about,
      this.dob,
      this.regionId,
      this.regionName,
      this.regionFlagUrl,
      this.languageId,
      this.languageName,
      this.languageFlagUrl,
      this.preferedGender,
      this.isInfluencer,
      this.callRate,
      this.fcmId,
      this.onlineStatus,
      this.followers,
      this.favourites,
      this.totalPoint,
      this.visitorCount,
      this.isFollowing,
      this.isFavourite,
      this.followings,
      this.countryIp});

  int? id, age, visitorCount;
  String? providerDisplayName;

  List<String>? imageUrl;
  String? userName;
  String? gender;
  String? about;
  dynamic dob;
  int? regionId;
  String? regionName;
  String? regionFlagUrl;
  int? languageId;
  String? languageName;
  String? languageFlagUrl;
  String? preferedGender;
  int? isFollowing, isFavourite;
  int? callRate;
  String? fcmId;
  String? onlineStatus;
  int? followers, followings;
  int? favourites;
  String? totalPoint;
  bool? isInfluencer;
  String? countryIp;

  factory MatchProfileModel.fromJson(Map<String, dynamic> json) =>
      MatchProfileModel(
          id: json["id"],
          age: json["age"],
          isFollowing: json["is_following"],
          isFavourite: json["is_favourite"],
          visitorCount: json["visitor_count"],
          providerDisplayName: json["provider_display_name"],
          imageUrl: List<String>.from(json["image_url"].map((x) => x)),
          userName: json["user_name"],
          gender: json["gender"],
          about: json["about"],
          dob: json["dob"],
          regionId: json["region_id"],
          regionName: json["region_name"],
          regionFlagUrl: json["region_flag_url"],
          languageId: json["language_id"],
          languageName: json["language_name"],
          languageFlagUrl: json["language_flag_url"],
          preferedGender: json["prefered_gender"],
          isInfluencer: json["is_influencer"],
          callRate: json["call_rate"],
          fcmId: json["fcm_id"],
          onlineStatus: json["online_status"],
          followers: json["followers"],
          favourites: json["favourites"],
          totalPoint: json["total_point"],
          followings: json["followings"],
          countryIp: json["country_ip"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "age": age,
        "is_following": isFollowing,
        "is_favourite": isFavourite,
        "visitor_count": visitorCount,
        "followings": followings,
        "provider_display_name": providerDisplayName,
        "image_url": List<dynamic>.from(imageUrl!.map((x) => x)),
        "user_name": userName,
        "gender": gender,
        "about": about,
        "dob": dob,
        "region_id": regionId,
        "region_name": regionName,
        "region_flag_url": regionFlagUrl,
        "language_id": languageId,
        "language_name": languageName,
        "language_flag_url": languageFlagUrl,
        "prefered_gender": preferedGender,
        "is_influencer": isInfluencer,
        "call_rate": callRate,
        "fcm_id": fcmId,
        "online_status": onlineStatus,
        "followers": followers,
        "favourites": favourites,
        "total_point": totalPoint,
        "country_ip": countryIp,
      };
}
