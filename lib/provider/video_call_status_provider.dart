import 'package:flutter/material.dart';

class VideoCallStatusProvider with ChangeNotifier {
  CallStatus callStatus;
  CallStatus get getCallStatus => this.callStatus;

  set setCallStatus(CallStatus callStatus) {
    this.callStatus = callStatus;
    notifyListeners();
  }

  String get statusText => getCallStatus == CallStatus.Start
      ? "Rigging..."
      : getCallStatus == CallStatus.Reject
          ? "Call Decline"
          : getCallStatus == CallStatus.End
              ? "Call Ended"
              : "";
}

enum CallStatus { End, Start, Receive, Reject,None }
