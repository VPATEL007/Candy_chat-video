import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

class MatchedProfile extends StatefulWidget {
  final String name;
  final String id, fromId;
  final String toImageUrl, fromImageUrl, channelName, token, toGender;
  MatchedProfile(
      {Key key,
      @required this.id,
      @required this.fromId,
      @required this.toImageUrl,
      @required this.fromImageUrl,
      @required this.name,
      @required this.channelName,
      @required this.token,
      @required this.toGender})
      : super(key: key);

  @override
  _MatchedProfileState createState() => _MatchedProfileState();
}

class _MatchedProfileState extends State<MatchedProfile> {
  List<ProductDetails> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.bgColor,
        body: Consumer<VideoCallStatusProvider>(
          builder: (context, videoCallStatus, child) => SafeArea(
            child: Container(
              width: MathUtilities.screenWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getSize(37),
                  ),
                  Center(
                    child: getColorText("Congratulations", ColorConstants.red,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: getSize(14),
                  ),
                  Center(
                    child: Text(
                      videoCallStatus.statusText,
                      style: appTheme.black14Normal.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(16)),
                    ),
                  ),
                  SizedBox(
                    height: getSize(26),
                  ),
                  getProfileWidget(),
                  SizedBox(
                    height: getSize(56),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getColorText("It’s a", ColorConstants.black,
                          fontSize: 35),
                      SizedBox(
                        width: getSize(8),
                      ),
                      getColorText("Match!", ColorConstants.red, fontSize: 35),
                    ],
                  ),
                  SizedBox(
                    height: getSize(12),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        "You are invited to a video call with ${widget.name}.",
                        style: appTheme.black14Normal.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(16)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Spacer(),
                  getCallButton(videoCallStatus.callStatus),
                  SizedBox(
                    height: getSize(10),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  getCallButton(CallStatus callStatus) {
    if (callStatus == CallStatus.Busy) {
      AgoraService.instance.updateCallStatus(
          channelName: widget.channelName,
          sessionId: widget.token,
          status: "busy");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (callStatus == CallStatus.Busy) {
              return;
            }
            Navigator.pop(context);
            AgoraService.instance.sendRejectCallMessage(widget.id);
            AgoraService.instance.updateCallStatus(
                channelName: widget.channelName,
                sessionId: widget.token,
                status: "reject");
          },
          child: Image.asset(
            icCallEnd,
            height: getSize(120),
            width: getSize(120),
          ),
        ),
        callStatus == CallStatus.Start || callStatus == CallStatus.Reject
            ? Container()
            : SizedBox(
                width: getSize(36),
              ),
        callStatus == CallStatus.Start || callStatus == CallStatus.Reject
            ? Container()
            : InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  UserModel userModel = Provider.of<FollowesProvider>(
                          navigationKey.currentContext,
                          listen: false)
                      .userModel;
                  if (userModel.isInfluencer == false) {
                    await Provider.of<MatchingProfileProvider>(context,
                            listen: false)
                        .checkCoinBalance(
                            context, int.parse(widget.id), widget.name ?? "");

                    CoinModel coins = Provider.of<MatchingProfileProvider>(
                            context,
                            listen: false)
                        .coinBalance;

                    if (coins?.lowBalance == true) {
                      InAppPurchase.instance.openCoinPurchasePopUp();
                      AgoraService.instance.inSufficientCoinMessage(widget.id);
                      return;
                    }
                  }

                  await Provider.of<MatchingProfileProvider>(context,
                          listen: false)
                      .receiveVideoCall(
                          context, widget.token, widget.channelName);
                  CallStatusModel coinStatus =
                      Provider.of<MatchingProfileProvider>(
                              navigationKey.currentContext,
                              listen: false)
                          .coinStatus;

                  if (coinStatus?.continueCall == true) {
                    AgoraService.instance.sendReceiveCallMessage(widget.id);
                    AgoraService.instance.openVideoCall(
                        channelName: widget.channelName,
                        sessionId: widget.token,
                        toUserId: widget.id);
                  } else {
                    InAppPurchase.instance.openCoinPurchasePopUp();
                    AgoraService.instance.inSufficientCoinMessage(widget.id);
                  }
                },
                child: Image.asset(
                  icCallAccept,
                  height: getSize(120),
                  width: getSize(120),
                ),
              )
      ],
    );
  }

  getProfileWidget() {
    return Center(
      child: Container(
        width: MathUtilities.screenWidth(context) - getSize(120),
        height: getSize(290),
        child: Stack(
          children: [
            new RotationTransition(
              turns: new AlwaysStoppedAnimation(-10 / 360),
              child: Padding(
                padding: EdgeInsets.only(top: getSize(20), left: getSize(20)),
                child: Container(
                  height: getSize(210),
                  width: getSize(156),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 7,
                          spreadRadius: 5,
                          offset: Offset(0, 3)),
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(
                      getSize(20),
                    ),
                    // image: DecorationImage(
                    //   image: CachedNetworkImageProvider(widget.toImageUrl),
                    //   onError: (exception, stackTrace) => Image.asset(
                    //     "assets/Profile/no_image.png",
                    //     fit: BoxFit.cover,
                    //   ),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getSize(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.toImageUrl,
                      width: getSize(156),
                      height: getSize(210),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        getUserPlaceHolder(widget.toGender ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: new RotationTransition(
                turns: new AlwaysStoppedAnimation(10 / 360),
                child: Container(
                  height: getSize(210),
                  width: getSize(156),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 7,
                          spreadRadius: 5,
                          offset: Offset(0, 3)),
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(
                      getSize(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getSize(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.fromImageUrl,
                      width: getSize(156),
                      height: getSize(210),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        getUserPlaceHolder(Provider.of<FollowesProvider>(
                                    context,
                                    listen: false)
                                .userModel
                                ?.gender ??
                            ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: getSize(100),
                bottom: getSize(40),
                child: Image.asset(
                  icHeart,
                  height: getSize(60),
                ))
          ],
        ),
      ),
    );
  }
}
