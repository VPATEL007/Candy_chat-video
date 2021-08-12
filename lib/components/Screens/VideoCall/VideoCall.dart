import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/KeyConsant.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:video_chat/app/utils/CommonTextfield.dart';

class VideoCall extends StatefulWidget {
  VideoCall({Key key}) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final TextEditingController _chatController = TextEditingController();
  RtcEngine engine;
  bool _joined = false;
  bool _switch = false;
  bool _micMute = false;
  bool _videoMute = false;
  int _remoteUid = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initPlatformState();
    });
  }

  @override
  void dispose() {
    // destroy sdk
    engine.leaveChannel();
    engine.destroy();
    super.dispose();
  }

  // Init the app
  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext config = RtcEngineContext(AGORA_APPID);
    engine = await RtcEngine.createWithContext(config);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
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
    }, error: (e) {
      print(e);
    }));
    // Enable video
    await engine.enableVideo();
    await engine.joinChannel(AGORA_TOKEN, "test", null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      body: Stack(
        children: [
          Container(
            child: _renderRemoteVideo(),
          ),
          Positioned(
              left: getSize(30),
              top: getSize(30),
              child: SafeArea(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: getSize(120),
                    height: getSize(160),
                    color: Colors.black,
                    child: _renderLocalPreview(),
                  ),
                ),
              )),
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
                            inputController: _chatController),
                        textCallback: (text) {},
                      )),
                      SizedBox(
                        width: getSize(12),
                      ),
                      InkWell(
                          onTap: () {
                            _onMicMute();
                          },
                          child: getMicVideoButton(unMuteMic)),
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
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: EdgeInsets.all(getSize(10)),
                          child: Image.asset(
                            icGift,
                            height: getSize(36),
                            width: getSize(36),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getSize(12),
                      ),
                      Image.asset(icEndVideoCall,
                          height: getSize(46), width: getSize(46))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget getMicVideoButton(String image) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(50)),
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

//Mic Mute
  void _onMicMute() {
    setState(() {
      _micMute = !_micMute;
    });
    engine.muteLocalAudioStream(_micMute);
  }

  //Video Mute
  void _onVideoMute() {
    setState(() {
      _videoMute = !_videoMute;
    });
    engine.muteLocalVideoStream(_videoMute);
  }

//Switch
  void _onSwitchCamera() {
    engine.switchCamera();
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
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return Center(
        child: Text(
          'Please wait remote user join',
          textAlign: TextAlign.center,
          style: appTheme.black16Medium,
        ),
      );
    }
  }
}
