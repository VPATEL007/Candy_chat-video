class CallStatusModel {
  bool? continueCall;
  bool? lowBalance;
  // int newBalance;
  // double minutesRemaining;

  CallStatusModel({
    this.continueCall,
    this.lowBalance,
  });

  CallStatusModel.fromJson(Map<String, dynamic> json) {
    continueCall = json['continueCall'];
    lowBalance = json['lowBalance'];
    // newBalance = json['newBalance'];
    // minutesRemaining = json['minutesRemaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['continueCall'] = this.continueCall;
    data['lowBalance'] = this.lowBalance;
    // data['newBalance'] = this.newBalance;
    // data['minutesRemaining'] = this.minutesRemaining;
    return data;
  }
}

class CoinModel {
  bool? lowBalance;
  // double maxCallMinutes;

  CoinModel({
    this.lowBalance,
    // this.maxCallMinutes
  });

  CoinModel.fromJson(Map<String, dynamic> json) {
    lowBalance = json['low_balance'];
    // maxCallMinutes = json['max_call_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['low_balance'] = this.lowBalance;
    // data['max_call_minutes'] = this.maxCallMinutes;
    return data;
  }
}
