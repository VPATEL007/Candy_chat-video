import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/CallMessage.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/tags_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

import 'apps_flyer/apps_flyer_keys.dart';
import 'apps_flyer/apps_flyer_service.dart';

class AgoraService {
  AgoraService._();

  static AgoraService instance = AgoraService._();

  AgoraRtmClient? _client;

  AgoraRtmClient? get client => this._client;

  AgoraRtmChannel? _channel;
  bool isOngoingCall = false;
  String? RTMToken;

  Future<void> initialize(String appId) async {
    try {
      if (appId.isEmpty) throw "APP_ID missing, please provide your APP_ID";
      _client = await AgoraRtmClient.createInstance(appId);

      // Directory appDocDir = await getApplicationDocumentsDirectory();

      // _client?.setLog(1, 524288, appDocDir.path);
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
        debugPrint("Peer msg: " + peerId + ", msg: " + message.text);
        StartVideoCallModel videoCallModel =
            startVideoCallModelFromJson((message.text));
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

  Future<AgoraRtmChannel?> _createChannel(
    String name,
  ) async {
    try {
      AgoraRtmChannel? channel = await _client?.createChannel(name);
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

  Future<void> login({required String token, required String userId}) async {
    try {
      // await _client.logout();

      RTMToken = token;
      print(token + "," + userId);
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

  //send Reverse Like Message
  sendReverseLikeMessage(String toUserId, BuildContext context) async {
    Map<String, dynamic> req = {};
    req["isReverseLike"] = true;
    var user = Provider.of<FollowesProvider>(context, listen: false).userModel;
    req["name"] = user?.userName;
    req["to_gender"] = user?.gender;
    req["user_id"] = user?.id;

    var image = user?.userImages;
    if (image != null && image.length > 0) {
      req["image"] = image.first;
    } else {
      req["image"] = UserImage(photoUrl: "");
    }

    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //send Like Message
  sendLikeMessage(String toUserId, BuildContext context) async {
    Map<String, dynamic> req = {};
    req["isLike"] = true;
    var user = Provider.of<FollowesProvider>(context, listen: false).userModel;
    req["name"] = user?.userName ?? "";
    req["to_gender"] = user?.gender ?? "";
    req["user_id"] = user?.id;

    var image = user?.userImages;
    if (image != null && image.length > 0) {
      req["image"] = image.first;
    } else {
      req["image"] = UserImage(photoUrl: "");
    }

    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

//Start Call
  sendVideoCallMessage(String toUserId, String sessionId, String channelName,
      String toGender, BuildContext context) async {
    Map<String, dynamic> req = {};
    req["VideoCall"] = true;
    var user = Provider.of<FollowesProvider>(context, listen: false).userModel;
    req["name"] = user?.userName ?? "";
    req["session_id"] = sessionId;
    req["channel_name"] = channelName;
    req["to_gender"] = toGender;

    var image = user?.userImages;
    if (image != null && image.length > 0) {
      req["image"] = image.first;
    } else {
      req["image"] = UserImage(photoUrl: "");
    }

    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
    final Map eventValues = {
      "from_user_id": "${user!.uid}",
      "to_user_id": "$user"
    };
    AppsFlyerService.appsFlyerService
        .logData(AppsFlyerKeys.registration, eventValues);
  }

//Reject Call
  sendRejectCallMessage(String toUserId) async {
    isOngoingCall = false;
    Map<String, dynamic> req = {};
    req["RejectCall"] = true;
    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //Busy Call
  sendBusyCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["BusyCall"] = true;
    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //Receive Call
  sendReceiveCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["ReceiveCall"] = true;
    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //End Call
  endCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["EndCall"] = true;
    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //Drop Call
  dropCallMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["DropCall"] = true;
    await _client?.sendMessageToPeer(
        toUserId, AgoraRtmMessage.fromText(jsonEncode(req)));
  }

  //inSufficientCoin Call
  inSufficientCoinMessage(String toUserId) async {
    Map<String, dynamic> req = {};
    req["InSufficientCoin"] = true;
    await _client?.sendMessageToPeer(
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
      if (message.isEmpty) {
        throw 'Please input text to send.';
      }

      await _channel?.sendMessage(
          AgoraRtmMessage.fromText(message), true, true);
      print("Message Sent");
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<AgoraRtmMember>?> getChannelMembers() async {
    try {
      List<AgoraRtmMember>? members = await _channel?.getMembers();
      return members;
    } on AgoraRtmClientException catch (e) {
      throw e.reason.toString();
    } on AgoraRtmChannelException catch (e) {
      throw e.reason.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> joinChannel(String channelId,
      {Function(AgoraRtmMember)? onMemberJoined,
      Function(AgoraRtmMember)? onMemberLeft,
      Function(AgoraRtmMessage, AgoraRtmMember)? onMessageReceived}) async {
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
        _client?.releaseChannel(_channel!.channelId ?? "");
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
        Provider.of<VideoCallStatusProvider>(navigationKey.currentContext!,
            listen: false);
    if (model.videoCall == true) {
      mutedProvider.setCallStatus = CallStatus.None;
    } else if (model.rejectCall == true) {
      mutedProvider.setCallStatus = CallStatus.Reject;
    } else if (model.receiveCall == true) {
      mutedProvider.setCallStatus = CallStatus.Receive;
    } else if (model.endCall == true) {
      mutedProvider.setCallStatus = CallStatus.End;
    } else if (model.busyCall == true) {
      mutedProvider.setCallStatus = CallStatus.Busy;
    } else if (model.inSufficientCoin == true) {
      mutedProvider.setCallStatus = CallStatus.InSufficientCoin;
    }
  }

  Future<void> handleVideoCallEvent(
      StartVideoCallModel model, String peerId) async {
    UserModel? userModel = Provider.of<FollowesProvider>(
            navigationKey.currentContext!,
            listen: false)
        .userModel;
    setCallStatus(model);

    if (model.isLike == true) {
      Flushbar? flush;
      flush = Flushbar(
        padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: ColorConstants.button,
        message: "likes you!",
        titleText: Text(
          model.name ?? "",
          style: appTheme?.white14Bold,
        ),
        mainButton: InkWell(
          onTap: () {
            flush?.dismiss();
            sendReverseLikeMessage(model.userId.toString(),
                NavigationUtilities.key.currentState!.overlay!.context);
          },
          child: Text(
            'Click To Like Me',
            style: appTheme?.white14Bold,
          ),
        ),
        duration: Duration(seconds: 20),
      );
      flush.show(NavigationUtilities.key.currentState!.overlay!.context);
    } else if (model.isReverseLike == true) {
      Navigator.pop(NavigationUtilities.key.currentState!.overlay!.context);
      NavigationUtilities.push(CallMessage(
          userId: model.userId ?? 0,
          name: model.name ?? "",
          gender: model.toGender ?? "",
          imageUrl: model.image?.photoUrl ?? ""));
    } else if (model.videoCall == true) {
      if (isOngoingCall == true) {
        sendBusyCallMessage(peerId);
        return;
      }

      NavigationUtilities.push(MatchedProfile(
        id: peerId,
        name: model.name ?? "",
        toImageUrl: model.image?.photoUrl ?? "",
        fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
            ? ""
            : userModel?.userImages?.first.photoUrl ?? "",
        channelName: model.channelName ?? "",
        token: model.sessionId ?? "",
        fromId: app.resolve<PrefUtils>().getUserDetails()?.id.toString() ?? "",
        toGender: model.toGender ?? "",
      ));
    } else if (model.rejectCall == true) {
      if (isOngoingCall == true) {
        return;
      }

      Future.delayed(Duration(seconds: 1), () {
        NavigationUtilities.pop();
      });

      isOngoingCall = false;
      //Reject Call

    } else if (model.receiveCall == true) {
      //Receive Call
      late VideoCallModel videoCallModel = Provider.of<MatchingProfileProvider>(
              navigationKey.currentContext!,
              listen: false)
          .videoCallModel!;
      NavigationUtilities.pop();
      openVideoCall(
          channelName: videoCallModel.channelName!,
          sessionId: videoCallModel.sessionId!,
          toUserId: videoCallModel.toUserId.toString());
    } else if (model.endCall == true) {
      isOngoingCall = false;
      NavigationUtilities.pop();
      print("endCall");

      VideoCallState().endCall();
      leaveChannel();
    } else if (model.busyCall == true) {
      Future.delayed(Duration(seconds: 2), () {
        NavigationUtilities.pop();
        View.showMessage(NavigationUtilities.key.currentState!.overlay!.context,
            "I am currently on another call.");
      });
    } else if (model.inSufficientCoin == true) {
      Future.delayed(Duration(seconds: 1), () {
        NavigationUtilities.pop();
      });
    }
  }

//Open Video Call
  openVideoCall(
      {required String channelName,
      required String sessionId,
      required String toUserId}) {
    isOngoingCall = true;
    // UserModel user = Provider.of<FollowesProvider>(navigationKey.currentContext,
    //         listen: false)
    //     .userModel;

    NavigationUtilities.push(
      VideoCall(
          channelName: channelName,
          token: sessionId,
          userId:
              app.resolve<PrefUtils>().getUserDetails()?.id.toString() ?? "",
          toUserId: toUserId),
    );
  }

  updateCallStatus(
      {required String channelName,
      required String sessionId,
      required String status}) {
    Map<String, dynamic> req = {};
    req["channel_name"] = channelName;
    req["call_status"] = status;
    req["session_id"] = sessionId;
    NetworkClient.getInstance.callApi(
      context: navigationKey.currentContext!,
      params: req,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.updateCallStatus,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Patch,
      successCallback: (response, message) async {},
      failureCallback: (code, message) {},
    );
  }

//Opne UserFeedBack After Call
  openUserFeedBackPopUp(int userId) async {
    UserModel? userModel = Provider.of<FollowesProvider>(
            navigationKey.currentContext!,
            listen: false)
        .userModel;
    if (userModel?.isInfluencer == true) return;

    var provider = Provider.of<TagsProvider>(
        NavigationUtilities.key.currentState!.overlay!.context,
        listen: false);
    await provider.fetchTags(
        NavigationUtilities.key.currentState!.overlay!.context, 0);
    List<String> selectedTags = [];
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: NavigationUtilities.key.currentState!.overlay!.context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: getSize(23), left: getSize(26), right: getSize(26)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Feedback",
                            style: appTheme?.black16Bold
                                .copyWith(fontSize: getFontSize(25)),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Close",
                              style: appTheme?.black14SemiBold.copyWith(
                                  fontSize: getFontSize(18),
                                  color: ColorConstants.red),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: getSize(18),
                      ),
                      GridView.builder(
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, childAspectRatio: 2.5),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.tagsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (selectedTags.contains(
                                    provider.tagsList[index].id.toString())) {
                                  selectedTags.remove(
                                      provider.tagsList[index].id.toString());
                                } else {
                                  selectedTags.add(
                                      provider.tagsList[index].id.toString());
                                }
                                setState(() {});
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 6, bottom: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedTags.contains(provider
                                                  .tagsList[index].id
                                                  .toString())
                                              ? ColorConstants.red
                                              : Colors.white,
                                          width: 1),
                                      color: selectedTags.contains(provider
                                              .tagsList[index].id
                                              .toString())
                                          ? fromHex("#FFDFDF")
                                          : fromHex("#F1F1F1"),
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Center(
                                    child: Text(
                                      provider.tagsList[index].tag ?? "",
                                      style: appTheme!.black12Normal.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: selectedTags.contains(provider
                                                  .tagsList[index].id
                                                  .toString())
                                              ? ColorConstants.red
                                              : Colors.black),
                                    ),
                                  )),
                            );
                            // return getCoinItem(index == 0, context);
                          }),
                      // Container(
                      //   child: Tags(
                      //       itemCount: provider.tagsList.length,
                      //       spacing: getSize(8),
                      //       runSpacing: getSize(20),
                      //       alignment: WrapAlignment.center,
                      //       itemBuilder: (int index) {
                      //         return ItemTags(
                      //           active: false,
                      //           pressEnabled: true,
                      //           activeColor: fromHex("#FFDFDF"),
                      //           title: provider.tagsList[index].tag ?? "",
                      //           index: index,
                      //           textStyle: appTheme!.black12Normal
                      //               .copyWith(fontWeight: FontWeight.w500),
                      //           textColor: Colors.black,
                      //           textActiveColor: ColorConstants.red,
                      //           color: fromHex("#F1F1F1"),
                      //           elevation: 0,
                      //           padding: EdgeInsets.only(
                      //               left: getSize(16),
                      //               right: getSize(16),
                      //               top: getSize(7),
                      //               bottom: getSize(7)),
                      //           onPressed: (item) {
                      // if (selectedTags.contains(provider
                      //     .tagsList[item.index ?? 0].id
                      //     .toString())) {
                      //   selectedTags.remove(provider
                      //       .tagsList[item.index ?? 0].id
                      //       .toString());
                      // } else {
                      //   selectedTags.add(provider
                      //       .tagsList[item.index ?? 0].id
                      //       .toString());
                      // }
                      //           },
                      //         );
                      //       }),
                      // ),
                      SizedBox(
                        height: getSize(35),
                      ),
                      getPopBottomButton(context, "Submit", () {
                        provider.submitTags(context, selectedTags, userId);
                        Navigator.pop(context);
                      })
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
