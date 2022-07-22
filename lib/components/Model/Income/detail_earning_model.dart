import 'dart:convert';

List<Details> detailEarningModelFromJson(String str) =>
    List<Details>.from(
        jsonDecode(str).map((e) => Details.fromJson(e)));

String detailEarningModelToJson(Details data) =>
    json.encode(data.toJson());

class DetailEarningReportModel {
  Vidocall? vidocall;
  Vidocall? gifts;
  Match? match;
  Vidocall? refral;
  Vidocall? albums;

  DetailEarningReportModel(
      {this.vidocall, this.gifts, this.match, this.refral, this.albums});

  DetailEarningReportModel.fromJson(Map<String, dynamic> json) {
    vidocall = json['vidocall'] != null
        ? new Vidocall.fromJson(json['vidocall'])
        : null;
    gifts = json['gifts'] != null ? new Vidocall.fromJson(json['gifts']) : null;
    match = json['match'] != null ? new Match.fromJson(json['match']) : null;
    refral =
        json['refral'] != null ? new Vidocall.fromJson(json['refral']) : null;
    albums =
        json['albums'] != null ? new Vidocall.fromJson(json['albums']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vidocall != null) {
      data['vidocall'] = this.vidocall!.toJson();
    }
    if (this.gifts != null) {
      data['gifts'] = this.gifts!.toJson();
    }
    if (this.match != null) {
      data['match'] = this.match!.toJson();
    }
    if (this.refral != null) {
      data['refral'] = this.refral!.toJson();
    }
    if (this.albums != null) {
      data['albums'] = this.albums!.toJson();
    }
    return data;
  }
}

class Vidocall {
  int? total;
  List<Details>? details;

  Vidocall({this.total, this.details});

  Vidocall.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? time;
  int? callDuration;
  String? calltype;
  int? coin;
  User? user;

  Details({this.time, this.callDuration, this.calltype, this.coin, this.user});

  Details.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    callDuration = json['call_duration'];
    calltype = json['calltype'];
    coin = json['coin'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['call_duration'] = this.callDuration;
    data['calltype'] = this.calltype;
    data['coin'] = this.coin;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? photoUrl;
  String? userName;

  User({this.id, this.photoUrl, this.userName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photo_url'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_url'] = this.photoUrl;
    data['user_name'] = this.userName;
    return data;
  }
}

class DetailEarning {
  String? time;
  int? coin;
  User? user;

  DetailEarning({this.time, this.coin, this.user});

  DetailEarning.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    coin = json['coin'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['coin'] = this.coin;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Match {
  int? total;
  List<Details>? details;

  Match({this.total, this.details});

  Match.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
