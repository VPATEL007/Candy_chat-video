import 'dart:convert';

VideoCallModel videoCallModelFromJson(String str) =>
    VideoCallModel.fromJson(json.decode(str));

String videoCallModelToJson(VideoCallModel data) => json.encode(data.toJson());

class VideoCallModel {
  VideoCallModel({
    this.fromUserId,
    this.toUserId,
    this.id,
    this.startedOn,
    this.sessionId,
    this.callType,
    this.callStatus,
    this.channelName,
  });

  int fromUserId;
  int toUserId;
  int id;
  StartedOn startedOn;
  String sessionId;
  String callType;
  String callStatus;
  String channelName;

  factory VideoCallModel.fromJson(Map<String, dynamic> json) => VideoCallModel(
        fromUserId: json["from_user_id"],
        toUserId: json["to_user_id"],
        id: json["id"],
        startedOn: StartedOn.fromJson(json["started_on"]),
        sessionId: json["session_id"],
        callType: json["call_type"],
        callStatus: json["call_status"],
        channelName: json["channel_name"],
      );

  Map<String, dynamic> toJson() => {
        "from_user_id": fromUserId,
        "to_user_id": toUserId,
        "id": id,
        "started_on": startedOn.toJson(),
        "session_id": sessionId,
        "call_type": callType,
        "call_status": callStatus,
        "channel_name": channelName,
      };
}

class StartedOn {
  StartedOn({
    this.val,
  });

  String val;

  factory StartedOn.fromJson(Map<String, dynamic> json) => StartedOn(
        val: json["val"],
      );

  Map<String, dynamic> toJson() => {
        "val": val,
      };
}
