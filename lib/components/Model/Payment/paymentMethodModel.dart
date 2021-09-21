import 'dart:convert';

List<PaymentMethodModel> paymentMethodModelFromJson(String str) =>
    List<PaymentMethodModel>.from(
        jsonDecode(str).map((e) => PaymentMethodModel.fromJson(e)));

String paymentMethodModelToJson(PaymentMethodModel data) =>
    json.encode(data.toJson());

class PaymentMethodModel {
  int? id;
  String? name;

  PaymentMethodModel({this.id, this.name});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
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
