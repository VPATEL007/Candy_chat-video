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
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

class MatchedProfile extends StatefulWidget {
  final String name;
  final String id, fromId;
  final String toImageUrl, fromImageUrl, channelName, token;
  MatchedProfile(
      {Key key,
      @required this.id,
      @required this.fromId,
      @required this.toImageUrl,
      @required this.fromImageUrl,
      @required this.name,
      @required this.channelName,
      @required this.token})
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
                    height: getSize(37),
                  ),
                  getProfileWidget(),
                  SizedBox(
                    height: getSize(60),
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
                  Center(
                    child: Text(
                      "${widget.name} invites you to a video call",
                      style: appTheme.black14Normal.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(16)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            AgoraService.instance.sendRejectCallMessage(widget.id);
          },
          child: Image.asset(
            icCallEnd,
            height: getSize(120),
            width: getSize(120),
          ),
        ),
        SizedBox(
          width: getSize(36),
        ),
        callStatus == CallStatus.Start || callStatus == CallStatus.Reject
            ? Container()
            : InkWell(
                onTap: () {
                  AgoraService.instance.sendReceiveCallMessage(widget.id);
                  Navigator.pop(context);
                  Provider.of<MatchingProfileProvider>(context, listen: false)
                      .receiveVideoCall(
                          context, widget.token, widget.channelName);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoCall(
                        channelName: widget.channelName,
                        token: widget.token,
                        userId: widget.fromId,
                        toUserId: widget.id),
                  ));
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
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.toImageUrl),
                      onError: (exception, stackTrace) => Image.asset(
                        "assets/Profile/no_image.png",
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
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
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.fromImageUrl),
                      onError: (exception, stackTrace) => Image.asset(
                        "assets/Profile/no_image.png",
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
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

  openCoinPurchasePopUp() async {
    _products = await InAppPurchase.instance.getProducts(context);
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
                    top: getSize(23), left: getSize(26), right: getSize(26)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Insufficient Coins",
                          style: appTheme.black16Bold
                              .copyWith(fontSize: getFontSize(25)),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: appTheme.black14SemiBold.copyWith(
                                fontSize: getFontSize(18),
                                color: ColorConstants.red),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getSize(19),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          icCoin,
                          height: getSize(20),
                        ),
                        SizedBox(
                          width: getSize(8),
                        ),
                        Text(
                          "30/min",
                          style: appTheme.black12Normal.copyWith(
                              fontSize: getFontSize(18),
                              color: ColorConstants.red),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getSize(13),
                    ),
                    Text(
                      "Recharge to enable 1 to 1 Video chat.",
                      style: appTheme.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: getSize(26),
                    ),
                    GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                InAppPurchase.instance
                                    .purchaseProduct(_products[index]);
                              },
                              child: getCoinItem(
                                  _products[index], false, context));
                          // return getCoinItem(index == 0, context);
                        }),
                    SizedBox(
                      height: getSize(22),
                    ),
                    getPopBottomButton(context, "Apply", () {})
                  ],
                ),
              ));
            },
          );
        });
  }
}
