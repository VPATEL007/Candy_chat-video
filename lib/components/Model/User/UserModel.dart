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
      this.isFollowing,
      this.isFavourite,
      this.isInfluencer,
      this.totalPoint,
      this.countryIp,
      this.coinBalance,
      this.coinsEarned});

  String? userName;
  String? email;
  String? phone;
  int? id;
  int? uid;
  String? providerDisplayName;
  String? photoUrl;
  String? gender;
  int? callRate;
  String? dob;
  String? preferedGender;
  String? about;
  int? byUserUserFollowers;
  int? userFollowers;
  int? userVisiteds;
  Region? region;
  List<UserImage>? userImages;
  Language? language;
  String? totalPoint;
  String? onlineStatus;
  bool? isFollowing = false, isFavourite = false;
  bool? isInfluencer;
  String? countryIp;
  num? coinBalance;
  num? coinsEarned;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userName: json["user_name"],
      email: json["email"],
      phone: json["phone"],
      id: json["id"],
      isInfluencer: json["is_influencer"] == 1
          ? true
          : json["is_influencer"] == 0
              ? false
              : json["is_influencer"],
      uid: int.tryParse(json["uid"].toString()),
      providerDisplayName: json["provider_display_name"],
      photoUrl: json["photo_url"],
      gender: json["gender"],
      callRate: json["call_rate"],
      dob: json["dob"],
      preferedGender: json["prefered_gender"],
      about: json["about"],
      coinBalance: json["coin_balance"],
      byUserUserFollowers: json["followingCount"] == null
          ? json["followings"]
          : json["followingCount"],
      userFollowers: json["followersCount"] == null
          ? json["followers"]
          : json["followersCount"],
      region: json["region"] == null ? null : Region.fromJson(json["region"]),
      userImages: json["user_images"] == null
          ? []
          : List<UserImage>.from(
              json["user_images"].map((x) => UserImage.fromJson(x))),
      language:
          json["language"] == null ? null : Language.fromJson(json["language"]),
      totalPoint: json["total_point"],
      onlineStatus: json["online_status"],
      userVisiteds: json["visitorCount"] == null
          ? json["visitor_count"]
          : json["visitorCount"],
      countryIp: json["country_ip"],
      coinsEarned: json["coins_earned"],
      isFollowing: json["is_following"] == 1 ? true : false,
      isFavourite: json["is_favourite"] == 1 ? true : false);

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
        "is_influencer": isInfluencer,
        "country_ip": countryIp,
        "coin_balance": coinBalance,
        "coins_earned": coinsEarned,
        "user_images": List<dynamic>.from(userImages!.map((x) => x.toJson())),
      };

  UserModel? get toCloneInfo => UserModel.fromJson(this.toJson());

  Map<String, dynamic> toUpdateJson() => {
        "user_name": userName,
        "id": id,
        "photo_url": List<dynamic>.from(userImages!.map((x) => x.toJson())),
        "gender": gender,
        "dob": dob,
        "region": region?.toJson(),
      };

  String getUserImage() {
    if ((userImages?.length ?? 0) > 0) {
      return userImages?.first.photoUrl ?? "";
    }

    return photoUrl ?? "";
  }
}

class Language {
  Language({
    this.languageName,
  });

  String? languageName;

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

  String? regionName, regionFlagUrl;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
      regionName: json["region_name"], regionFlagUrl: json["region_flag_url"]);

  Map<String, dynamic> toJson() =>
      {"region_name": regionName, "region_flag_url": regionFlagUrl};
}

class UserImage {
  UserImage({this.id, this.photoUrl = "", this.assetPath = ""});

  int? id;
  String photoUrl, assetPath;

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        id: json["id"],
        photoUrl: json["photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo_url": photoUrl,
      };
}
