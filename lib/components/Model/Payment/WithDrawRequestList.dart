import 'dart:convert';

List<WithDrawListModel> withDrawListModelFromJson(String str) =>
    List<WithDrawListModel>.from(
        jsonDecode(str).map((e) => WithDrawListModel.fromJson(e)));

String withDrawListToJson(WithDrawListModel data) => json.encode(data.toJson());

class WithDrawListModel {
  int? id;
  int? userId;
  int? coins;
  String? requestStatus;
  DateTime? createdOn;
  String? updatedOn;
  PaymentMethod? paymentMethod;
  String? paymentId;
  String? transactionId;
  int? requestStatusCode;

  WithDrawListModel(
      {this.id,
      this.userId,
      this.coins,
      this.requestStatus,
      this.createdOn,
      this.updatedOn,
      this.paymentMethod,
      this.paymentId,
      this.transactionId,
      this.requestStatusCode});

  WithDrawListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    coins = json['coins'];
    requestStatus = json['request_status'];
    createdOn = DateTime.parse(json["created_on"]);
    updatedOn = json['updated_on'];
    paymentMethod = json['payment_method'] != null
        ? new PaymentMethod.fromJson(json['payment_method'])
        : null;
    paymentId = json['payment_id'];
    transactionId = json['transaction_id'];
    requestStatusCode = json['request_status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coins'] = this.coins;
    data['request_status'] = this.requestStatus;
    data['created_on'] = this.createdOn?.toIso8601String();
    data['updated_on'] = this.updatedOn;
    if (this.paymentMethod != null) {
      data['payment_method'] = this.paymentMethod?.toJson();
    }
    data['payment_id'] = this.paymentId;
    data['transaction_id'] = this.transactionId;
    data['request_status_code'] = this.requestStatusCode;
    return data;
  }
}

class PaymentMethod {
  int? id;
  String? name;

  PaymentMethod({this.id, this.name});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
