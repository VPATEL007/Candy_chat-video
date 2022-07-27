class DailyEarningReportModel {
  String? date;
  int? totalCoins;
  int? videoCallCoins;
  int? giftsCoin;
  int? matchCoin;
  int? albumCoin;
  int? refralCoins;
  String? weeklyCallDuration;

  DailyEarningReportModel(
      {this.date,
      this.totalCoins,
      this.videoCallCoins,
      this.giftsCoin,
      this.matchCoin,
      this.albumCoin,
      this.refralCoins,
      this.weeklyCallDuration});

  DailyEarningReportModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    totalCoins = json['totalCoins'];
    videoCallCoins = json['videoCallCoins'];
    giftsCoin = json['giftsCoin'];
    matchCoin = json['matchCoin'];
    albumCoin = json['AlbumCoin'];
    refralCoins = json['refralCoins'];
    weeklyCallDuration = json['weeklyCallDuration'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['totalCoins'] = this.totalCoins;
    data['videoCallCoins'] = this.videoCallCoins;
    data['giftsCoin'] = this.giftsCoin;
    data['matchCoin'] = this.matchCoin;
    data['AlbumCoin'] = this.albumCoin;
    data['refralCoins'] = this.refralCoins;
    data['weeklyCallDuration'] = this.weeklyCallDuration;
    return data;
  }
}

class WeeklyEariningReportModel {
  String? date;
  int? totalCoins;
  int? videoCallCoins;
  int? giftsCoin;
  int? matchCoin;
  int? albumCoin;
  int? refralCoins;
  String? weeklyCallDuration;

  WeeklyEariningReportModel(
      {this.date,
      this.totalCoins,
      this.videoCallCoins,
      this.giftsCoin,
      this.matchCoin,
      this.albumCoin,
      this.refralCoins,
      this.weeklyCallDuration});

  WeeklyEariningReportModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    totalCoins = json['totalCoins'];
    videoCallCoins = json['videoCallCoins'];
    giftsCoin = json['giftsCoin'];
    matchCoin = json['matchCoin'];
    albumCoin = json['AlbumCoin'];
    refralCoins = json['refralCoins'];
    weeklyCallDuration = json['weeklyCallDuration'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['totalCoins'] = this.totalCoins;
    data['videoCallCoins'] = this.videoCallCoins;
    data['giftsCoin'] = this.giftsCoin;
    data['matchCoin'] = this.matchCoin;
    data['AlbumCoin'] = this.albumCoin;
    data['refralCoins'] = this.refralCoins;
    data['weeklyCallDuration'] = this.weeklyCallDuration;
    return data;
  }
}
