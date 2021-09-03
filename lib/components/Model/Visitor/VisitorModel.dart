import 'dart:convert';

List<VisitorModel> visitorListModelFromJson(String str) =>
    List<VisitorModel>.from(
        jsonDecode(str).map((e) => VisitorModel.fromJson(e)));

class VisitorModel {
  int id;
  String createdOn;
  String photoUrl;
  String country;
  List<String> imageUrl;
  String userName;
  String time;
  String gender;

  VisitorModel(
      {this.id,
      this.createdOn,
      this.photoUrl,
      this.country,
      this.imageUrl,
      this.userName,
      this.time,
      this.gender});

  VisitorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['created_on'];
    photoUrl = json['photo_url'];
    country = json['country'];
    imageUrl = json['image_url'].cast<String>();
    userName = json['user_name'];
    time = json['time'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_on'] = this.createdOn;
    data['photo_url'] = this.photoUrl;
    data['country'] = this.country;
    data['image_url'] = this.imageUrl;
    data['user_name'] = this.userName;
    data['time'] = this.time;
    data['gender'] = this.gender;
    return data;
  }

  String getUserImage() {
    if (imageUrl.length > 0) {
      return imageUrl.first ?? "";
    }
    return photoUrl ?? "";
  }
}
