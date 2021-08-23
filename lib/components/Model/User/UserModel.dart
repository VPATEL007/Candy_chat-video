// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel(
      {this.userName,
      this.email,
      this.phone,
      this.id,
      this.uid,
      this.providerDisplayName,
      this.photoUrl,
      this.gender,
      this.callRate,
      this.dob,
      this.preferedGender,
      this.about,
      this.byUserUserFollowers,
      this.userFollowers,
      this.region,
      this.userImages,
      this.language,
      this.onlineStatus,
      this.userVisiteds,
      this.totalPoint});

  String userName;
  String email;
  String phone;
  int id;
  int uid;
  String providerDisplayName;
  String photoUrl;
  String gender;
  int callRate;
  dynamic dob;
  String preferedGender;
  String about;
  List<ByUserUserFollower> byUserUserFollowers;
  List<ByUserUserFollower> userFollowers;
  List<UserVisited> userVisiteds;
  Region region;
  List<UserImage> userImages;
  Language language;
  String totalPoint;
  String onlineStatus;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName: json["user_name"],
        email: json["email"],
        phone: json["phone"],
        id: json["id"],
        uid: int.tryParse(json["uid"].toString()),
        providerDisplayName: json["provider_display_name"],
        photoUrl: json["photo_url"],
        gender: json["gender"],
        callRate: json["call_rate"],
        dob: json["dob"],
        preferedGender: json["prefered_gender"],
        about: json["about"],
        byUserUserFollowers: json["by_user_user_followers"] == null
            ? []
            : List<ByUserUserFollower>.from(json["by_user_user_followers"]
                .map((x) => ByUserUserFollower.fromJson(x))),
        userFollowers: json["user_followers"] == null
            ? []
            : List<ByUserUserFollower>.from(json["user_followers"]
                .map((x) => ByUserUserFollower.fromJson(x))),
        region: json["region"] == null ? null : Region.fromJson(json["region"]),
        userImages: json["user_images"] == null
            ? []
            : List<UserImage>.from(
                json["user_images"].map((x) => UserImage.fromJson(x))),
        language: json["language"] == null
            ? null
            : Language.fromJson(json["language"]),
        totalPoint: json["total_point"],
        onlineStatus: json["online_status"],
        userVisiteds: json["user_visiteds"] == null
            ? []
            : List<UserVisited>.from(
                json["user_visiteds"].map((x) => UserVisited.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "email": email,
        "phone": phone,
        "id": id,
        "uid": uid,
        "provider_display_name": providerDisplayName,
        "photo_url": photoUrl,
        "gender": gender,
        "call_rate": callRate,
        "dob": dob,
        "prefered_gender": preferedGender,
        "about": about,
        "region": region?.toJson(),
        "language": language?.toJson(),
        "total_point": totalPoint,
        "online_status": onlineStatus,
        "user_images": List<dynamic>.from(userImages.map((x) => x.toJson())),
      };
}

class ByUserUserFollower {
  ByUserUserFollower({
    this.followersCount,
  });

  int followersCount;
  bool isFollowByMe = false;

  factory ByUserUserFollower.fromJson(Map<String, dynamic> json) =>
      ByUserUserFollower(
        followersCount: json["followersCount"],
      );

  Map<String, dynamic> toJson() => {
        "followersCount": followersCount,
      };
}

class Language {
  Language({
    this.languageName,
  });

  String languageName;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        languageName: json["language_name"],
      );

  Map<String, dynamic> toJson() => {
        "language_name": languageName,
      };
}

class Region {
  Region({
    this.regionName,
    this.regionFlagUrl,
  });

  String regionName, regionFlagUrl;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
      regionName: json["region_name"], regionFlagUrl: json["region_flag_url"]);

  Map<String, dynamic> toJson() =>
      {"region_name": regionName, "region_flag_url": regionFlagUrl};
}

class UserImage {
  UserImage({
    this.photoUrl,
  });

  String photoUrl;

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        photoUrl: json["photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "photo_url": photoUrl,
      };
}

class UserVisited {
  UserVisited({
    this.visitorsCount,
  });

  int visitorsCount;

  factory UserVisited.fromJson(Map<String, dynamic> json) => UserVisited(
        visitorsCount: json["visitorsCount"],
      );

  Map<String, dynamic> toJson() => {
        "visitorsCount": visitorsCount,
      };
}
