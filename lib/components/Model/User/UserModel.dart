class UserModel {
  String email;
  int languageId;
  String photoUrl;
  String uid;
  int userId;

  UserModel(
      {this.email, this.languageId, this.photoUrl, this.uid, this.userId});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    languageId = json['language_id'];
    photoUrl = json['photo_url'];
    uid = json['uid'];
    userId = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['language_id'] = this.languageId;
    data['photo_url'] = this.photoUrl;
    data['uid'] = this.uid;
    data["id"] = this.userId;
    return data;
  }
}
