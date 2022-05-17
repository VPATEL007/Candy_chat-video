class SearchProfileModel {
  String? status;
  String? message;
  String? messageCode;
  bool? success;
  Data? data;
  int? statusCode;

  SearchProfileModel(
      {this.status,
      this.message,
      this.messageCode,
      this.success,
      this.data,
      this.statusCode});

  SearchProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    messageCode = json['messageCode'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['messageCode'] = this.messageCode;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class Data {
  SearchProfileResult? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new SearchProfileResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class SearchProfileResult {
  List<SearchProfileData>? data;
  int? pages;
  int? totalRecords;

  SearchProfileResult({this.data, this.pages, this.totalRecords});

  SearchProfileResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SearchProfileData>[];
      json['data'].forEach((v) {
        data!.add(new SearchProfileData.fromJson(v));
      });
    }
    pages = json['pages'];
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pages'] = this.pages;
    data['totalRecords'] = this.totalRecords;
    return data;
  }
}

class SearchProfileData {
  int? id;
  String? userName;
  String? photoUrl;
  String? onlineStatus;
  String? userLevel;
  bool? liked;
  List<String>? imageUrl;
  bool? callProbability;

  SearchProfileData(
      {this.id,
      this.userName,
      this.photoUrl,
      this.onlineStatus,
      this.userLevel,
      this.liked,
      this.imageUrl,
      this.callProbability});

  SearchProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    photoUrl = json['photo_url'];
    onlineStatus = json['online_status'];
    userLevel = json['user_level'];
    liked = json['liked'];
    imageUrl = json['image_url'].cast<String>();
    callProbability = json['call_probability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['photo_url'] = this.photoUrl;
    data['online_status'] = this.onlineStatus;
    data['user_level'] = this.userLevel;
    data['liked'] = this.liked;
    data['image_url'] = this.imageUrl;
    data['call_probability'] = this.callProbability;
    return data;
  }
}
