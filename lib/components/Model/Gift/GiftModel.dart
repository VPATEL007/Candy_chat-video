import 'dart:convert';

List<GiftModel> giftModelFromJson(String str) =>
    List<GiftModel>.from(jsonDecode(str).map((e) => GiftModel.fromJson(e)));

String giftModelToJson(GiftModel data) => json.encode(data.toJson());

class GiftModel {
  int id;
  String giftName;
  String detail;
  String imageUrl;
  String price;
  String actualPrice;
  String currency;
  bool isActive;

  GiftModel(
      {this.id,
      this.giftName,
      this.detail,
      this.imageUrl,
      this.price,
      this.actualPrice,
      this.currency,
      this.isActive});

  GiftModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    giftName = json['gift_name'];
    detail = json['detail'];
    imageUrl = json['image_url'];
    price = json['price'];
    actualPrice = json['actual_price'];
    currency = json['currency'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gift_name'] = this.giftName;
    data['detail'] = this.detail;
    data['image_url'] = this.imageUrl;
    data['price'] = this.price;
    data['actual_price'] = this.actualPrice;
    data['currency'] = this.currency;
    data['is_active'] = this.isActive;
    return data;
  }
}
