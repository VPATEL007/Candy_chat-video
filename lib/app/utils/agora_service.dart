import 'dart:async';
import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

class AgoraService {
  AgoraService._();

  static AgoraService instance = AgoraService._();

  AgoraRtmClient _client;
  AgoraRtmClient get client => this._client;

  AgoraRtmChannel _channel;

  Future<void> initialize(String appId) async {
    try {
      if (appId.isEmpty) throw "APP_ID missing, please provide your APP_ID";
      _client = await AgoraRtmClient.createInstance(appId);
      _client?.onConnectionStateChanged = (int state, int reason) {
        debugPrint('Connection state changed: ' +
            state.toString() +
            ', reason: ' +
            reason.toString());

        if (state == 5) {
          _client?.logout();
        }
      };
      _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
        debugPrint("Peer msg: " + peerId + ", msg: " + (message.text ?? ""));
        StartVideoCallModel videoCallModel =
            startVideoCallModelFromJson((message.text ?? ""));
        if (videoCallModel == null) return;
        handleVideoCallEvent(videoCallModel, peerId);
      };
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AgoraRtmChannel> _createChannel(
    String name,
  ) async {
    try {
      AgoraRtmChannel channel = await _client?.createChannel(name);
      channel?.onError = (msg) {
        throw msg.toString();
      };

      return channel;
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> login({@required String token, @required String userId}) async {
    try {
      // await _client.logout();
      await _client?.login(token, userId);
      debugPrint('Login success: ' + userId);
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

//Start Call
  sendVideoCallMessage(String toUserId, String sessionId, String channelName,
      BuildContext context) async {
    Map<String, dynamic> req = {};
    req["VideoCall"] = true;
    var user = Provider.of<FollowesProvider>(context, listen: false).userModel;
    req["name"] = user.providerDisplayName;
    req["session_id"] = sessionId;
    req["channel_name"] = channelName;

    var image = user.userImages;
    if (image != null && image.length > 0) {
      req["image"] = image?.first ?? UserImage(photoUrl: "");
    } else {
      req["image"] = UserImage(photoUrl: "");
    }

    await _client.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

//Reject Call
  sendRejectCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["RejectCall"] = true;
    await _client.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //Receive Call
  sendReceiveCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["ReceiveCall"] = true;
    await _client.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //End Call
  endCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["EndCall"] = true;
    await _client.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //Drop Call
  dropCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["DropCall"] = true;
    await _client.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  Future<void> logOut() async {
    try {
      await _client?.logout();
      debugPrint('logout success: ');
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      if (message?.isEmpty ?? true) {
        throw 'Please input text to send.';
      }
      await _channel?.sendMessage(AgoraRtmMessage.fromText(message));
      print("Message Sent");
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<AgoraRtmMember>> getChannelMembers() async {
    try {
      List<AgoraRtmMember> members = await _channel?.getMembers();
      return (members?.isEmpty ?? true) ? [] : members;
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> joinChannel(String channelId,
      {Function(AgoraRtmMember) onMemberJoined,
      Function(AgoraRtmMember) onMemberLeft,
      Function(AgoraRtmMessage, AgoraRtmMember) onMessageReceived}) async {
    try {
      if (channelId.isEmpty) {
        debugPrint('Please input channel id to join.');
        return;
      }

      _channel = await _createChannel(
        channelId,
      );
      await _channel?.join();
      if (_channel != null) {
        _channel?.onMemberJoined = onMemberJoined;
        _channel?.onMemberLeft = onMemberLeft;
        _channel?.onMessageReceived = onMessageReceived;
      }

      debugPrint('Join channel success.');
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> leaveChannel() async {
    try {
      await _channel?.leave();
      debugPrint('Leave channel success.');
      if (_channel != null) {
        _client?.releaseChannel(_channel?.channelId);
      }
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  void setCallStatus(StartVideoCallModel model) {
    VideoCallStatusProvider mutedProvider =
        Provider.of<VideoCallStatusProvider>(navigationKey.currentContext,
            listen: false);
    if (model.videoCall == true) {
      mutedProvider.setCallStatus = CallStatus.None;
    } else if (model.rejectCall == true) {
      mutedProvider.setCallStatus = CallStatus.Reject;
    } else if (model.receiveCall == true) {
      mutedProvider.setCallStatus = CallStatus.Receive;
    } else if (model.endCall == true) {
      mutedProvider.setCallStatus = CallStatus.End;
    }
  }

  void handleVideoCallEvent(StartVideoCallModel model, String peerId) {
    UserModel userModel = Provider.of<FollowesProvider>(
            navigationKey.currentContext,
            listen: false)
        .userModel;
    setCallStatus(model);

    if (model.videoCall == true) {
      NavigationUtilities.push(MatchedProfile(
        id: peerId,
        name: model.name ?? "",
        toImageUrl: model?.image?.photoUrl ?? "",
        fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
            ? ""
            : userModel?.userImages?.first ?? "",
        channelName: model.channelName,
        token: model.sessionId,
        fromId: app.resolve<PrefUtils>().getUserDetails()?.id?.toString(),
      ));
    } else if (model.rejectCall == true) {
      Future.delayed(Duration(seconds: 1), () {
        NavigationUtilities.pop();
      });
      //Reject Call

    } else if (model.receiveCall == true) {
      //Receive Call
      VideoCallModel videoCallModel = Provider.of<MatchingProfileProvider>(
              navigationKey.currentContext,
              listen: false)
          .videoCallModel;
      NavigationUtilities.pop();
      Provider.of<MatchingProfileProvider>(navigationKey.currentContext,
              listen: false)
          .receiveVideoCall(navigationKey.currentContext,
              videoCallModel.sessionId, videoCallModel.channelName);
      NavigationUtilities.push(
        VideoCall(
            channelName: videoCallModel.channelName,
            token: videoCallModel.sessionId,
            userId: app.resolve<PrefUtils>().getUserDetails()?.id?.toString(),
            toUserId: peerId),
      );
    } else if (model.endCall == true) {
      print("endCall");
      View.showMessage(NavigationUtilities.key.currentContext, "Call Ended");
      // Future.delayed(Duration(seconds: 1), () {
        NavigationUtilities.pop();
      // });
      //End Call
    }
  }
}
