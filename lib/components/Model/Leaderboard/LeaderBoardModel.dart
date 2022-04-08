import 'dart:convert';

List<LeaderBoardModel> leaderBoardModelFromJson(String str) =>
    List<LeaderBoardModel>.from(
        jsonDecode(str).map((e) => LeaderBoardModel.fromJson(e)));

String leaderBoardModelToJson(LeaderBoardModel data) =>
    json.encode(data.toJson());

class LeaderBoardModel {
  int? id;
  String? name;
  String? date;
  int? callDuration;
  int? coins;
  int? giftCoins;
  num? earning;

  LeaderBoardModel({this.id, this.name, this.callDuration, this.coins});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    callDuration = json['call_duration'];
    coins = json['coins'];
    giftCoins = json['gift_coins'];
    date = json['date'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['call_duration'] = this.callDuration;
    data['coins'] = this.coins;
    data['gift_coins'] = this.giftCoins;
    data['date'] = this.date;
    return data;
  }
}
