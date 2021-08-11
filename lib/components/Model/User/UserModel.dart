class UserModel {
  String email;
  int languageId;
  String photoUrl;
  String uid;

  UserModel({this.email, this.languageId, this.photoUrl, this.uid});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    languageId = json['language_id'];
    photoUrl = json['photo_url'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['language_id'] = this.languageId;
    data['photo_url'] = this.photoUrl;
    data['uid'] = this.uid;
    return data;
  }
}
