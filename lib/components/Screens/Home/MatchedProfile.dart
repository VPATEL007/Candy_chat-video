import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class MatchedProfile extends StatefulWidget {
  MatchedProfile({Key key}) : super(key: key);

  @override
  _MatchedProfileState createState() => _MatchedProfileState();
}

class _MatchedProfileState extends State<MatchedProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.bgColor,
        body: SafeArea(
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
                    "You and Piyu like each other!",
                    style: appTheme.black14Normal.copyWith(
                        fontWeight: FontWeight.w500, fontSize: getFontSize(16)),
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
                    getColorText("It’s a", ColorConstants.black, fontSize: 35),
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
                    "Pihu invites you to a video call",
                    style: appTheme.black14Normal.copyWith(
                        fontWeight: FontWeight.w500, fontSize: getFontSize(16)),
                  ),
                ),
                Spacer(),
                getCallButton(),
                SizedBox(
                  height: getSize(10),
                ),
              ],
            ),
          ),
        ));
  }

  getCallButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
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
        InkWell(
          onTap: () {
            openCoinPurchasePopUp();
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

//Received Call
  receivedCall() {}

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
                      image: AssetImage(icTemp),
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
                      image: AssetImage(loginBg),
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

  openCoinPurchasePopUp() {
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
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container();
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
