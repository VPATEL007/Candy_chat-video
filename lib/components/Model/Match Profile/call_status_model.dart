class CallStatusTypeModel {
  CallStatusTypeTwo? callStatusTypeTwo;
  String? sessionId;
  String? chanelName;
  String? callType;

  CallStatusTypeModel(
      {this.callStatusTypeTwo, this.sessionId, this.chanelName, this.callType});

  CallStatusTypeModel.fromJson(Map<String, dynamic> json) {
    callStatusTypeTwo = json['call_status'] != null
        ? new CallStatusTypeTwo.fromJson(json['call_status'])
        : null;
    sessionId = json['session_id'];
    chanelName = json['chanel_name'];
    callType = json['callType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.callStatusTypeTwo != null) {
      data['call_status'] = this.callStatusTypeTwo!.toJson();
    }
    data['session_id'] = this.sessionId;
    data['chanel_name'] = this.chanelName;
    data['callType'] = this.callType;
    return data;
  }
}

class CallStatusTypeTwo {
  bool? continueCall;
  bool? lowBalance;
  int? newBalance;
  int? minutesRemaining;

  CallStatusTypeTwo(
      {this.continueCall,
      this.lowBalance,
      this.newBalance,
      this.minutesRemaining});

  CallStatusTypeTwo.fromJson(Map<String, dynamic> json) {
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
