import 'package:flutter/material.dart';

class VideoCallStatusProvider with ChangeNotifier {
  CallStatus? callStatus;
  CallStatus? get getCallStatus => this.callStatus;

  set setCallStatus(CallStatus callStatus) {
    this.callStatus = callStatus;
    notifyListeners();
  }

  String get statusText => getCallStatus == CallStatus.Start
      ? "Ringing…"
      : getCallStatus == CallStatus.Reject
          ? "Call Decline"
          : getCallStatus == CallStatus.End
              ? "Call Ended"
              : getCallStatus == CallStatus.Busy
                  ? "Busy"
                  : getCallStatus == CallStatus.InSufficientCoin
                      ? "Insufficient Coins"
                      : "";
}

enum CallStatus { End, Start, Receive, Reject, None, Busy, InSufficientCoin }
