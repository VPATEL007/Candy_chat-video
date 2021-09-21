class NotificationModel {
  String? userId;
  String? type;

  NotificationModel({this.userId, this.type});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['type'] = this.type;
    return data;
  }
}
