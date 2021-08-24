class CallStatusModel {
  bool continueCall;
  bool lowBalance;
  int newBalance;
  int minutesRemaining;

  CallStatusModel(
      {this.continueCall,
      this.lowBalance,
      this.newBalance,
      this.minutesRemaining});

  CallStatusModel.fromJson(Map<String, dynamic> json) {
    continueCall = json['continueCall'];
    lowBalance = json['lowBalance'];
    newBalance = json['newBalance'];
    minutesRemaining = json['minutesRemaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['continueCall'] = this.continueCall;
    data['lowBalance'] = this.lowBalance;
    data['newBalance'] = this.newBalance;
    data['minutesRemaining'] = this.minutesRemaining;
    return data;
  }
}
