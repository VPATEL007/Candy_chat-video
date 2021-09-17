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

StartVideoCallModel startVideoCallModelFromJson(String str) =>
    StartVideoCallModel.fromJson(json.decode(str));

String startVideoCallModelToJson(StartVideoCallModel data) =>
    json.encode(data.toJson());

class StartVideoCallModel {
  StartVideoCallModel(
      {this.videoCall,
      this.name,
      this.sessionId,
      this.channelName,
      this.image,
      this.rejectCall,
      this.receiveCall,
      this.endCall,
      this.busyCall,
      this.toGender,
      this.inSufficientCoin,
      this.isLike,
      this.userId,
      this.isReverseLike});

  bool videoCall;
  String name;
  String sessionId;
  String channelName;
  ImageResponse image;
  bool rejectCall;
  bool receiveCall;
  bool endCall;
  bool busyCall;
  bool inSufficientCoin;
  bool isReverseLike;
  bool isLike;
  String toGender;
  int userId;

  factory StartVideoCallModel.fromJson(Map<String, dynamic> json) =>
      StartVideoCallModel(
        videoCall: json["VideoCall"],
        rejectCall: json["RejectCall"],
        receiveCall: json["ReceiveCall"],
        inSufficientCoin: json["InSufficientCoin"],
        endCall: json["EndCall"],
        busyCall: json["BusyCall"],
        name: json["name"],
        sessionId: json["session_id"],
        channelName: json["channel_name"],
        toGender: json["to_gender"],
        isLike: json["isLike"],
        userId: json["user_id"],
        isReverseLike: json["isReverseLike"],
        image: json["image"] == null
            ? ImageResponse(photoUrl: "")
            : ImageResponse.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "VideoCall": videoCall,
        "isLike": isLike,
        "name": name,
        "session_id": sessionId,
        "channel_name": channelName,
        "image": image.toJson(),
        "RejectCall": rejectCall,
        "ReceiveCall": receiveCall,
        "EndCall": endCall,
        "BusyCall": busyCall,
        "user_id": userId,
        "isReverseLike": isReverseLike,
        "InSufficientCoin": inSufficientCoin
      };
}

class ImageResponse {
  ImageResponse({
    this.photoUrl,
  });

  String photoUrl;

  factory ImageResponse.fromJson(Map<String, dynamic> json) => ImageResponse(
        photoUrl: json["photo_url"],
      );

  Map<String, dynamic> toJson() => {
        "photo_url": photoUrl,
      };
}
