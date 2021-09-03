import 'dart:convert';

List<ReceivedGiftModel> receivedGiftModelFromJson(String str) =>
    List<ReceivedGiftModel>.from(
        jsonDecode(str).map((e) => ReceivedGiftModel.fromJson(e)));

String receivedGiftModelToJson(ReceivedGiftModel data) =>
    json.encode(data.toJson());

class ReceivedGiftModel {
  int giftId;
  Gift gift;
  int count;

  ReceivedGiftModel({this.giftId, this.gift, this.count});

  ReceivedGiftModel.fromJson(Map<String, dynamic> json) {
    giftId = json['gift_id'];
    gift = json['gift'] != null ? new Gift.fromJson(json['gift']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_id'] = this.giftId;
    if (this.gift != null) {
      data['gift'] = this.gift.toJson();
    }
    data['count'] = this.count;
    return data;
  }
}

class Gift {
  String giftName;
  String imageUrl;
  int id;

  Gift({this.giftName, this.imageUrl, this.id});

  Gift.fromJson(Map<String, dynamic> json) {
    giftName = json['gift_name'];
    imageUrl = json['image_url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_name'] = this.giftName;
    data['image_url'] = this.imageUrl;
    data['id'] = this.id;
    return data;
  }
}
