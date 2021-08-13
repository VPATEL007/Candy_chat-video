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
  MatchProfileModel({
    this.id,
    this.providerDisplayName,
    this.photoUrl,
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
    this.totalPoint,
  });

  int id;
  String providerDisplayName;
  String photoUrl;
  String userName;
  String gender;
  String about;
  dynamic dob;
  int regionId;
  String regionName;
  String regionFlagUrl;
  int languageId;
  String languageName;
  String languageFlagUrl;
  String preferedGender;
  int isInfluencer;
  int callRate;
  String fcmId;
  String onlineStatus;
  String totalPoint;

  factory MatchProfileModel.fromJson(Map<String, dynamic> json) =>
      MatchProfileModel(
        id: json["id"],
        providerDisplayName: json["provider_display_name"],
        photoUrl: json["photo_url"],
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
        totalPoint: json["total_point"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_display_name": providerDisplayName,
        "photo_url": photoUrl,
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
        "total_point": totalPoint,
      };
}
