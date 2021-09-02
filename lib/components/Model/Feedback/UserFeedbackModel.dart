import 'dart:convert';

List<UserFeedbackModel> userFeedBackModelFromJson(String str) =>
    List<UserFeedbackModel>.from(
        jsonDecode(str).map((e) => UserFeedbackModel.fromJson(e)));

class UserFeedbackModel {
  int id;
  int userId;
  int byUserId;
  int tagId;
  String createdOn;
  Tag tag;

  UserFeedbackModel(
      {this.id,
      this.userId,
      this.byUserId,
      this.tagId,
      this.createdOn,
      this.tag});

  UserFeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    byUserId = json['by_user_id'];
    tagId = json['tag_id'];
    createdOn = json['created_on'];
    tag = json['tag'] != null ? new Tag.fromJson(json['tag']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['by_user_id'] = this.byUserId;
    data['tag_id'] = this.tagId;
    data['created_on'] = this.createdOn;
    if (this.tag != null) {
      data['tag'] = this.tag.toJson();
    }
    return data;
  }
}

class Tag {
  String name;

  Tag({this.name});

  Tag.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
