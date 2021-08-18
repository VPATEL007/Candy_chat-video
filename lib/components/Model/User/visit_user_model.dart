// To parse this JSON data, do
//
//     final visitUserModel = visitUserModelFromJson(jsonString);

import 'dart:convert';

VisitUserModel visitUserModelFromJson(String str) =>
    VisitUserModel.fromJson(json.decode(str));

String visitUserModelToJson(VisitUserModel data) => json.encode(data.toJson());

class VisitUserModel {
  VisitUserModel({
    this.email,
    this.phone,
    this.providerDisplayName,
    this.photoUrl,
    this.gender,
    this.callRate,
    this.dob,
    this.preferedGender,
    this.about,
    this.region,
    this.userImages,
    this.language,
  });

  String email;
  String phone;
  String providerDisplayName;
  String photoUrl;
  String gender;
  int callRate;
  dynamic dob;
  String preferedGender;
  String about;
  Region region;
  List<UserImage> userImages;
  Language language;

  factory VisitUserModel.fromJson(Map<String, dynamic> json) => VisitUserModel(
        email: json["email"],
        phone: json["phone"],
        providerDisplayName: json["provider_display_name"],
        photoUrl: json["photo_url"],
        gender: json["gender"],
        callRate: json["call_rate"],
        dob: json["dob"],
        preferedGender: json["prefered_gender"],
        about: json["about"],
        region: Region.fromJson(json["region"]),
        userImages: List<UserImage>.from(
            json["user_images"].map((x) => UserImage.fromJson(x))),
        language: Language.fromJson(json["language"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "provider_display_name": providerDisplayName,
        "photo_url": photoUrl,
        "gender": gender,
        "call_rate": callRate,
        "dob": dob,
        "prefered_gender": preferedGender,
        "about": about,
        "region": region.toJson(),
        "user_images": List<dynamic>.from(userImages.map((x) => x.toJson())),
        "language": language.toJson(),
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
  });

  String regionName;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        regionName: json["region_name"],
      );

  Map<String, dynamic> toJson() => {
        "region_name": regionName,
      };
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
