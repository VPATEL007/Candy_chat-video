import 'dart:async';
import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/provider/followes_provider.dart';

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
        StartVideoCallModel startVideoCallModel =
            startVideoCallModelFromJson((message.text ?? ""));
        if (startVideoCallModel == null) return;
        UserModel userModel = Provider.of<FollowesProvider>(
                navigationKey.currentContext,
                listen: false)
            .userModel;
        if (startVideoCallModel.videoCall == true) {
          NavigationUtilities.push(MatchedProfile(
            id: peerId,
            name: startVideoCallModel.name ?? "",
            toImageUrl: startVideoCallModel?.image?.photoUrl ?? "",
            fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
                ? ""
                : userModel?.userImages?.first ?? "",
            channelName: startVideoCallModel.channelName,
            token: startVideoCallModel.sessionId,
            fromId: app.resolve<PrefUtils>().getUserDetails()?.id?.toString(),
          ));
        }
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
}
