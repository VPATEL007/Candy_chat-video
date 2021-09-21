import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/provider/chat_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

import 'MatchedProfile.dart';

class CallMessage extends StatefulWidget {
  String name, gender, imageUrl;
  int userId;

  CallMessage(
      {Key? key,
      required this.name,
      required this.gender,
      required this.imageUrl,
      required this.userId})
      : super(key: key);

  @override
  _CallMessageState createState() => _CallMessageState();
}

class _CallMessageState extends State<CallMessage> {
  UserModel? userModel = Provider.of<FollowesProvider>(
          navigationKey.currentContext!,
          listen: false)
      .userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: getSize(36),
            ),
            Center(
                child: Text(
              "It's Match",
              style: appTheme?.black16Bold.copyWith(
                  fontSize: getFontSize(36), color: ColorConstants.redText),
            )),
            SizedBox(
              height: 8,
            ),
            Text(
              "You and " + (widget.name) + " like each other!",
              style: appTheme?.black14SemiBold,
            ),
            // SizedBox(
            //   height: getSize(30),
            // ),
            Spacer(),
            getProfileWidget(),
            Spacer(),
            InkWell(
              onTap: () {
                startCall();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: fromHex("#00DE9B"),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    icCall,
                    color: Colors.white,
                    height: getSize(40),
                    width: getSize(40),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getSize(18),
            ),
            Text(
              "Video call to " + (widget.name),
              style: appTheme?.black14SemiBold,
            ),
            SizedBox(
              height: getSize(18),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Provider.of<ChatProvider>(context, listen: false)
                    .startChat(widget.userId, context, true);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.gradiantStart,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        icChatWhite,
                        width: 20,
                      ),
                      SizedBox(
                        width: getSize(16),
                      ),
                      Text(
                        "Say hello",
                        style: appTheme?.white16Normal.copyWith(
                            fontSize: getFontSize(18),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getSize(16),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                        color: ColorConstants.gradiantStart, width: 1)),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Continue Matching",
                        style: appTheme?.black14Normal.copyWith(
                            color: ColorConstants.gradiantStart,
                            fontSize: getFontSize(18),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getSize(20),
            )
          ],
        ),
      ),
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
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getSize(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: getSize(156),
                      height: getSize(210),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        getUserPlaceHolder(widget.gender),
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
                      imageUrl: (userModel?.userImages?.isEmpty ?? true)
                          ? ""
                          : userModel?.userImages?.first.photoUrl ?? "",
                      width: getSize(156),
                      height: getSize(210),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        getUserPlaceHolder(userModel?.gender ?? ""),
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

  startCall() async {
    await Provider.of<MatchingProfileProvider>(context, listen: false)
        .checkCoinBalance(context, widget.userId, widget.name);

    CoinModel? coins =
        Provider.of<MatchingProfileProvider>(context, listen: false)
            .coinBalance;

    if (coins?.lowBalance == false) {
      // discover.id = 41;
      await Provider.of<MatchingProfileProvider>(context, listen: false)
          .startVideoCall(context, widget.userId);
      VideoCallModel? videoCallModel =
          Provider.of<MatchingProfileProvider>(context, listen: false)
              .videoCallModel;

      if (videoCallModel != null) {
        // videoCallModel.toUserId = 41;
        Navigator.pop(context);
        AgoraService.instance.sendVideoCallMessage(
            videoCallModel.toUserId.toString(),
            videoCallModel.sessionId ?? "",
            videoCallModel.channelName ?? "",
            userModel?.gender ?? "",
            context);
        Provider.of<VideoCallStatusProvider>(context, listen: false)
            .setCallStatus = CallStatus.Start;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MatchedProfile(
            channelName: videoCallModel.channelName,
            token: videoCallModel.sessionId,
            fromId: videoCallModel.fromUserId.toString(),
            fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
                ? ""
                : userModel?.userImages?.first.photoUrl ?? "",
            name: widget.name,
            toImageUrl: widget.imageUrl,
            id: videoCallModel.toUserId.toString(),
            toGender: widget.gender,
          ),
        ));
      }
    } else if (coins?.lowBalance == true) {
      InAppPurchaseHelper.instance.openCoinPurchasePopUp();
    }
  }
}
