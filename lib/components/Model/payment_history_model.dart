// To parse this JSON data, do
//
//     final paymentHistoryModel = paymentHistoryModelFromJson(jsonString);

import 'dart:convert';

List<PaymentHistoryModel> paymentHistoryModelFromJson(String str) =>
    List<PaymentHistoryModel>.from(
        jsonDecode(str).map((e) => PaymentHistoryModel.fromJson(e)));

String paymentHistoryModelToJson(PaymentHistoryModel data) =>
    json.encode(data.toJson());

class PaymentHistoryModel {
  PaymentHistoryModel({
    this.id,
    this.paidAmount,
    this.currency,
    this.purchasedOn,
    this.gateway,
    this.transactionStatus,
    this.transactionId,
    this.data,
  });

  int? id;
  String? paidAmount;
  String? currency;
  DateTime? purchasedOn;
  String? gateway;
  String? transactionStatus;
  String? transactionId;
  Data? data;

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryModel(
        id: json["id"],
        paidAmount: json["paid_amount"],
        currency: json["currency"],
        purchasedOn: DateTime.parse(json["purchased_on"]),
        gateway: json["gateway"],
        transactionStatus: json["transaction_status"],
        transactionId: json["transaction_id"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paid_amount": paidAmount,
        "currency": currency,
        "purchased_on": purchasedOn?.toIso8601String(),
        "gateway": gateway,
        "transaction_status": transactionStatus,
        "transaction_id": transactionId,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.packageName,
    this.detail,
  });

  int? id;
  String? packageName;
  String? detail;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        packageName: json["package_name"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "detail": detail,
      };
}
