import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_screen/screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/KeyConsant.dart';
import 'package:video_chat/app/utils/CommonTextfield.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/provider/chat_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/gift_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';

import '../../../app/Helper/socket_helper.dart';
import '../../../utils/appLifeCycle.dart';
import '../../Model/Chat/chat_message_model.dart';
// import 'package:screen/screen.dart';

class VideoCall extends StatefulWidget {
  static const route = "VideoCall";
  final String token;
  final String channelName;
  final String userId;
  final String toUserId;

  VideoCall({
    Key? key,
    required this.channelName,
    required this.token,
    required this.userId,
    required this.toUserId,
  }) : super(key: key);

  @override
  VideoCallState createState() => VideoCallState();
}

class VideoCallState extends State<VideoCall> with WidgetsBindingObserver {
  final TextEditingController _chatController = TextEditingController();
  ScrollController messageListScrollController = ScrollController();
  RtcEngine? engine;
  bool _joined = false;
  bool _micMute = false;
  bool _videoMute = false;
  int _remoteUid = 0;
  bool isRemoteVideoMute = false;
  bool isRemoteAudioMute = false;
  AgoraService agoraService = AgoraService.instance;
  List<ChatMessageData> _chatsList = [];
  Timer? timer;
  bool isKeyboardOpen = false;
  UserModel? toUser;
  UserModel? fromUser;
  var keyboardVisibilityController = KeyboardVisibilityController();
  String? userId = app.resolve<PrefUtils>().getUserDetails()?.id.toString();
  int durationCounter = 0;
  Timer? duraationTimer;
  Socket? socket = SocketHealper.socket;
  bool isSwitch = false;

  CallStatusModel? callStatus = Provider.of<MatchingProfileProvider>(
          navigationKey.currentContext!,
          listen: false)
      .coinStatus;

  @override
  void initState() {
    if (socket?.disconnected ?? true) {
      SocketHealper.shared.connect();
    }

    super.initState();
    // WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addObserver(LifecycleEventHandler(
        detachedCallBack: () {},
        resumeCallBack: () {},
        pausedCallback: () {
          if (mounted) {
            autoEndCall();
            endCall();
            Navigator.pop(context);
          }
        },
        context: context));
    // Screen.keepOn(true);
    agoraService.isOngoingCall = true;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initPlatformState();
      clearData();
      // init();
      receiveMessage();
      getToUserDetail();
      startTimer();
    });

    fromUser = Provider.of<FollowesProvider>(context, listen: false).userModel;
    if (fromUser == null) {
      Provider.of<FollowesProvider>(context, listen: false)
          .fetchMyProfile(context)
          .then((_) {
        UserModel? user =
            Provider.of<FollowesProvider>(context, listen: false).userModel;
        if (user?.isInfluencer == false) {
          timer = Timer.periodic(
              Duration(seconds: 60), (Timer t) => callReceiveApiCall());
        }
      });
    } else {
      if (fromUser?.isInfluencer == false) {
        timer = Timer.periodic(
            Duration(seconds: 60), (Timer t) => callReceiveApiCall());
      }
    }

    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardOpen = visible;
      });
    });

    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     setState(() {
    //       isKeyboardOpen = visible;
    //     });
    //   },
    // );
  }

  clearData() {
    Provider.of<ChatProvider>(context, listen: false).chatMessage.clear();
  }

  receiveMessage() {
    socket?.on('getMessage', (data) {
      Provider.of<ChatProvider>(context, listen: false).addMessage(
          data['toSend'], data['sendBy'], data['message'], data['type']);
    });
  }

  autoEndCall() {
    agoraService.endCallMessage(widget.toUserId);
    agoraService.updateCallStatus(
        channelName: widget.channelName,
        sessionId: widget.token,
        status: "ended");
  }

  @override
  void dispose() {
    // destroy sdk
    agoraService.openUserFeedBackPopUp(toUser?.id ?? 0);
    agoraService.isOngoingCall = false;
    // Screen.keepOn(false);
    WidgetsBinding.instance?.removeObserver(LifecycleEventHandler(
        detachedCallBack: () {},
        resumeCallBack: () {},
        pausedCallback: () {},
        context: context));
    timer?.cancel();
    endCall();
    agoraService.leaveChannel();
    duraationTimer?.cancel();
    super.dispose();
    SocketHealper.shared.disconnect();
    SocketHealper.shared.connect();
  }

  void startTimer() {
    durationCounter = 0;
    duraationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        durationCounter++;
      });
    });
  }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  getToUserDetail() async {
    toUser = await Provider.of<ChatProvider>(context, listen: false)
        .getUserProfile(int.parse(widget.toUserId), context);
    setState(() {});
  }

  // Future<void> init() async {
  //   await agoraService.joinChannel((widget.channelName),
  //       onMemberJoined: (AgoraRtmMember member) {
  //     print(
  //         "Member joined: " + member.userId + ', channel: ' + member.channelId);
  //   }, onMemberLeft: (AgoraRtmMember member) {
  //     print("Member left: " + member.userId + ', channel: ' + member.channelId);
  //   }, onMessageReceived: (AgoraRtmMessage message, AgoraRtmMember member) {
  //     MessageObj _chat = MessageObj(
  //         chatDate: DateTime.now(),
  //         message: message.text,
  //         isSendByMe: member.userId.toString().toLowerCase() ==
  //             widget.userId.toLowerCase().toLowerCase(),
  //         sendBy: member.userId);
  //
  //     _chatsList.insert(0, _chat);
  //     // _chatsList.add(_chat);
  //     if (mounted) setState(() {});
  //     print("Channel msg: " + member.userId + ", msg: " + message.text);
  //   });
  // }

  // Init the app
  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext config = RtcEngineContext(AGORA_APPID);
    engine = await RtcEngine.createWithContext(config);
    // Define event handling logic
    engine?.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess $channel, $uid');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined $uid');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline $uid');
      setState(() {
        _remoteUid = 0;
      });
    }, remoteAudioStateChanged: (int uid, state, reason, int elapsed) {
      isRemoteAudioMute = state == AudioRemoteState.Stopped ? true : false;
      setState(() {});
    }, remoteVideoStateChanged: (int uid, state, reason, int elapsed) {
      isRemoteVideoMute = state == VideoRemoteState.Stopped ? true : false;
      setState(() {});
    }, error: (e) {
      print(e);
    }));
    // Enable video
    await engine?.enableVideo();
    await engine?.joinChannel(widget.token, widget.channelName, null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.colorPrimary,
        body: Stack(
          children: [
            Container(
              child: isRemoteVideoMute == true
                  ? Container(
                      color: Colors.black,
                    )
                  : (isSwitch == true
                      ? _renderLocalPreview()
                      : _renderRemoteVideo()),
            ),
            Positioned(bottom: getSize(120), child: chatList()),
            Positioned(
                left: getSize(30),
                top: getSize(30),
                child: Visibility(
                  visible: !_videoMute,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSwitch = !isSwitch;
                      });
                    },
                    child: SafeArea(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: getSize(120),
                          height: getSize(160),
                          color: Colors.black,
                          child: isSwitch == true
                              ? _renderRemoteVideo()
                              : _renderLocalPreview(),
                        ),
                      ),
                    ),
                  ),
                )),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 22, left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: getTitleText(
                            context, formatHHMMSS(durationCounter),
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: getSize(15),
                    ),
                    callStatus?.callType==null?SizedBox():Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        child: Text(callStatus?.callType ?? '',
                            style: appTheme?.black14SemiBold
                                .copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            switchCameraButton(),
            isRemoteAudioMute == true || isRemoteVideoMute
                ? Center(
                    child: Text(
                    (toUser?.userName ?? "") +
                        (isRemoteAudioMute == true && isRemoteVideoMute == true
                            ? " camera and microphone off"
                            : isRemoteAudioMute
                                ? " muted this call"
                                : isRemoteVideoMute
                                    ? " camera off"
                                    : ""),
                    style:
                        appTheme?.black14SemiBold.copyWith(color: Colors.white),
                  ))
                : SizedBox(),
            Positioned(
                bottom: getSize(40),
                child: Container(
                  width: MathUtilities.screenWidth(context),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: getSize(25), right: getSize(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: CommonTextfield(
                          textOption: TextFieldOption(
                              radious: getSize(26),
                              hintText: "Type text....",
                              maxLine: 1,
                              fillColor: fromHex("#F1F1F1"),
                              inputController: _chatController,
                              postfixWid: isKeyboardOpen
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: getSize(16), right: getSize(16)),
                                      child: InkWell(
                                        onTap: () async {
                                          if (_chatController.text.isEmpty)
                                            return;
                                          socket?.emit('sendMessage', {
                                            'sendBy': userId,
                                            'toSend': widget.toUserId,
                                            'message': _chatController.text,
                                            'type': 1,
                                            'giftUlr': ''
                                          });
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .addMessage(
                                                  widget.toUserId,
                                                  userId,
                                                  _chatController.text,
                                                  1);
                                          _chatController.clear();
                                        },
                                        child: Text(
                                          "Send",
                                          style: appTheme?.black14Normal
                                              .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorConstants.red),
                                        ),
                                      ),
                                    )
                                  : SizedBox()),
                          textCallback: (text) {},
                        )),
                        Visibility(
                          visible: true,
                          child: Row(
                            children: [
                              SizedBox(
                                width: getSize(12),
                              ),
                              InkWell(
                                  onTap: () {
                                    _onMicMute();
                                  },
                                  child: getMicVideoButton(
                                      _micMute ? muteMic : unMuteMic)),
                              SizedBox(
                                width: getSize(12),
                              ),
                              InkWell(
                                  onTap: () {
                                    _onVideoMute();
                                  },
                                  child: getMicVideoButton(
                                      _videoMute ? muteVideo : unMuteVideo)),
                              SizedBox(
                                width: getSize(12),
                              ),
                              giftButton(),
                              SizedBox(
                                width: getSize(12),
                              ),
                              // callEndButton()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget switchCameraButton() {
    return Positioned(
        right: getSize(40),
        top: getSize(40),
        child: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _onSwitchCamera();
                },
                child: Image.asset(
                  icSwitchCamera,
                  width: getSize(34),
                  height: getSize(34),
                  color: Colors.red,
                ),
              ),
              // SizedBox(
              //   height: 16,
              // ),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       isSwitch = !isSwitch;
              //     });
              //   },
              //   child: Image.asset(
              //     icSwitchView,
              //     width: getSize(25),
              //     height: getSize(25),
              //     color: Colors.red,
              //   ),
              // ),
            ],
            // InkWell(
            //   onTap: () {
            //     _onSwitchCamera();
            //   },
            //   child: Image.asset(
            //     icSwitchCamera,
            //     width: getSize(34),
            //     height: getSize(34),
            //     color: Colors.red,
            //   ),
            // ),
          ),
        ));
  }

  Widget giftButton() {
    return InkWell(
      onTap: () {
        // Provider.of<GiftProvider>(context, listen: false)
        //     .openGiftPopUp(int.parse(widget.toUserId));
        // Provider.of<GiftProvider>(context, listen: false)
        //     .openGiftPopUp(int.parse(widget.toUserId), (url) => () {});

        Provider.of<GiftProvider>(context, listen: false)
            .openGiftPopUp(int.parse(widget.toUserId), (url) async {
          socket?.emit('sendMessage', {
            'sendBy': userId,
            'toSend': widget.toUserId,
            'message': "isGift~$url",
            'type': 1,
            'giftUlr': ''
          });
          Provider.of<ChatProvider>(context, listen: false).addMessage(
              widget.toUserId, userId, "isGift~$url", 2,
              giftUrl: "isGift~$url");
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: EdgeInsets.all(getSize(10)),
          child: Image.asset(
            icGift,
            height: getSize(36),
            width: getSize(36),
          ),
        ),
      ),
    );
  }

  Widget callEndButton() {
    return InkWell(
        onTap: () {
          openEndCallConfirmation();
        },
        child: Image.asset(icEndVideoCall,
            height: getSize(46), width: getSize(46)));
  }

  Widget getMicVideoButton(String image) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Image.asset(
          image,
          height: getSize(26),
          width: getSize(26),
        ),
      ),
    );
  }

  Widget chatList() {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return _buildChats(chatProvider.chatMessage, chatProvider);
    });
    // return StreamBuilder<List<MessageObj>>(
    //     stream: Stream.value(_chatsList),
    //     builder: (context, snapshot) {
    //       if (snapshot.data?.isEmpty ?? true) {
    //         return Container();
    //       }
    //       return _buildChats(_chatsList);
    //     });
  }

  // Chat date and chats...
  Widget _buildChats(
      List<ChatMessageData> messageList, ChatProvider chatProvider) {
    return Container(
      height: getSize(200),
      width: MathUtilities.screenWidth(context),
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: getSize(25), right: getSize(25)),
        itemCount: messageList.length,
        controller: messageListScrollController,
        itemBuilder: (context, contentIndex) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              messageList[contentIndex].isGiftMessage() == true
                  ? Container(
                      child: CachedNetworkImage(
                        imageUrl: messageList[contentIndex].giftUlr ?? "",
                        width: getSize(45),
                        height: getSize(45),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                          noAttachment,
                          fit: BoxFit.cover,
                          height: getSize(45),
                          width: getSize(45),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: fromHex("#F1F1F1")),
                      child: Padding(
                        padding: EdgeInsets.all(getSize(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messageList[contentIndex].sendBy.toString() ==
                                      userId
                                  ? (fromUser?.userName ?? "from user")
                                  : (toUser?.userName ?? "to user"),
                              textAlign: TextAlign.left,
                              style: appTheme?.black14Normal
                                  .copyWith(color: Colors.red),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              messageList[contentIndex].message ?? "",
                              style: appTheme?.black16Medium
                                  .copyWith(fontSize: getSize(16)),
                            )
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }

  void endCall() {
    try {
      timer?.cancel();
      engine?.leaveChannel();
      engine?.pauseAllChannelMediaRelay();
      engine?.stopPreview();
      engine?.destroy();
      duraationTimer?.cancel();
    } catch (e) {
      print(e);
    }
  }

//Mic Mute
  void _onMicMute() {
    setState(() {
      _micMute = !_micMute;
    });
    engine?.muteLocalAudioStream(_micMute);
  }

  //Video Mute
  void _onVideoMute() {
    setState(() {
      _videoMute = !_videoMute;
    });
    engine?.muteLocalVideoStream(_videoMute);
  }

//Switch
  void _onSwitchCamera() {
    engine?.switchCamera();
  }

  // Local preview
  Widget _renderLocalPreview() {
    if (_joined) {
      return RtcLocalView.SurfaceView();
    } else {
      return SizedBox();
    }
  }

  // Remote preview
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid, channelId: '');
    } else {
      return Container();
    }
  }

  openEndCallConfirmation() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    left: getSize(35), right: getSize(35), top: getSize(35)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Are you sure you want to end your Video Call?",
                      textAlign: TextAlign.center,
                      style: appTheme?.black14SemiBold
                          .copyWith(fontSize: getFontSize(18)),
                    ),
                    SizedBox(
                      height: getSize(28),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: getSize(52),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorConstants.red, width: 1),
                            color: fromHex("#FFDFDF"),
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: Text("Cancel",
                                style: appTheme?.whiteBold32.copyWith(
                                    fontSize: getFontSize(18),
                                    color: ColorConstants.red))),
                      ),
                    ),
                    SizedBox(
                      height: getSize(24),
                    ),
                    getPopBottomButton(context, "End Video", () {
                      agoraService.updateCallStatus(
                          channelName: widget.channelName,
                          sessionId: widget.token,
                          status: "ended");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      agoraService.endCallMessage(widget.toUserId);

                      endCall();
                    })
                  ],
                ),
              ));
            },
          );
        });
  }

//Receive Video Call
  callReceiveApiCall() async {
    await Provider.of<MatchingProfileProvider>(navigationKey.currentContext!,
            listen: false)
        .receiveVideoCall(
            navigationKey.currentContext!, widget.token, widget.channelName);
    CallStatusModel? callStatus = Provider.of<MatchingProfileProvider>(
            navigationKey.currentContext!,
            listen: false)
        .coinStatus;

    if (callStatus?.callStatusTypeTwo?.continueCall == false) {
      Navigator.pop(context);
      agoraService.updateCallStatus(
          channelName: widget.channelName,
          sessionId: widget.token,
          status: "ended");
      agoraService.endCallMessage(widget.toUserId);
      endCall();
      View.showMessage(context, "Insufficient coin balance.");

      // InAppPurchase.instance.openCoinPurchasePopUp();
    }

    // if (callStatus?.lowBalance == true) {
    //
    // }
  }
}
