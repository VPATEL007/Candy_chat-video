import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/EnumConstant.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/app/utils/navigator.dart';
import 'package:video_chat/app/utils/pref_utils.dart';
import 'package:video_chat/components/Model/Leaderboard/LeaderBoardModel.dart';
import 'package:video_chat/components/Model/User/report_reason_model.dart';
import 'package:video_chat/components/Screens/OnboardingVerfication/VerificationInvitation.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/main.dart';

import '../Chat/Chat.dart';
import '../Home/MatchedProfile.dart';
import '../album/createAlbum.dart';
import '../permissionScreen.dart';

class LeaderBoard extends StatefulWidget {
  static const route = "LeaderBoard";

  LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;
  List<LeaderBoardModel> callDuration = [];
  List<LeaderBoardModel> giftCoins = [];
  bool isCall = true;
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getRtmToken();
      openVerificationPopUp();
      reqPermission();
      getCallDuration(showLoader: false);
    });
  }

  void reqPermission() async {
    var camStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    if (camStatus.isDenied == true || microphoneStatus.isDenied == true) {
      var cameraRequest = await Permission.camera.request();
      if (cameraRequest.isGranted == true) {
        var microPhone = await Permission.microphone.request();
        if (microPhone.isDenied == true) {
          NavigationUtilities.push(PermissionScreen());
        }
      } else {
        NavigationUtilities.push(PermissionScreen());
      }
    }
  }

  getRtmToken() async {
    bool isCompleted = await CommonApiHelper.shared.getRTMToken(context);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data['type'] == 'message') {
          print(
              'openNotification==> ${message.data['type']} ${message.data['user_id']}');
          NavigationUtilities.push(
              Chat(toUserId: int.parse(message.data['user_id'])));
          return;
        }

        print('openNotification==> ${message.data['type']}');

        if (message.data['type'] == 'videocall') {
          String userName = message.data['user_name'];
          print('name==> ${message.data['user_name']}');
          String toUserId = message.data['to_user_id'];
          String fromUserId = message.data['from_user_id'];
          String toImageUrl = message.data['toImageUrl'];
          String fromImageUrl = message.data['fromImageUrl'];
          String channelName = message.data['channel_name'];
          String sessionId = message.data['token'];
          String toGender = message.data['toGender'];
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MatchedProfile(
                channelName: channelName,
                token: sessionId,
                fromId: toUserId.toString(),
                fromImageUrl: fromImageUrl,
                name: userName,
                toImageUrl: toImageUrl,
                id: fromUserId.toString(),
                toGender: toGender),
          ));
          return;
        }
      }
    });
  }

  openVerificationPopUp() {
    var status = app.resolve<PrefUtils>().getUserDetails()?.isFacVerify;
    if (status == faceVerified) {
      return true;
    }

    String sStatus = "Unsubmitted";
    if (status == faceNotSubmitted) {
      sStatus = "Unsubmitted";
    } else if (status == facePandingApproval) {
      sStatus = "Pending For Approval";
    } else if (status == faceRejected) {
      sStatus = "Rejected";
    }

    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (builder) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return SafeArea(
                  child: Container(
                    color: ColorConstants.grayBackGround,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            color: ColorConstants.red,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(getSize(16)),
                            child: Text(
                                "You need to submit your profile to be an Anchor",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: getFontSize(18),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(getSize(16)),
                          child: InkWell(
                            onTap: () {
                              if (status == faceNotSubmitted ||
                                  status == faceRejected) {
                                NavigationUtilities.push(
                                    VerficationInvitation());
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: ColorConstants.red,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: EdgeInsets.all(getSize(16)),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Submit full profile and\nget approved",
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: getFontSize(16),
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(
                                          height: getSize(8),
                                        ),
                                        Text("Status : " + sStatus,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: getFontSize(14),
                                                color: status ==
                                                        facePandingApproval
                                                    ? Colors.red
                                                    : ColorConstants.red,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: ColorConstants.red,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 6,
                                            bottom: 6),
                                        child: Row(
                                          children: [
                                            Text("Next",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: getFontSize(14),
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
          ;
        });
  }

  getCallDuration({showLoader = true}) {
    Map<String, dynamic> req = {};
    req["callType"] = isCall == true ? "call" : "gift";
    req["agency_id"] = app.resolve<PrefUtils>().getUserDetails()?.agencyId ?? 0;

    if (showLoader) NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.influeencerLeaderboard,
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        if (showLoader) NetworkClient.getInstance.hideProgressDialog();

        if (response != null) {
          if (isCall) {
            callDuration =
                leaderBoardModelFromJson(jsonEncode(response["queryResult"]));
          } else {
            giftCoins =
                leaderBoardModelFromJson(jsonEncode(response["queryResult"]));
          }

          setState(() {});
        }
      },
      failureCallback: (code, message) {
        if (showLoader) NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.LeaderBoard,
      ),
      appBar: getAppBar(
        context,
        "Ranking",
        isWhite: false,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      isCall = true;
                      setState(() {});

                      if (callDuration.length == 0) {
                        getCallDuration();
                      }
                    },
                    child: getTabItem('Total call duration', isCall)),
                InkWell(
                    onTap: () {
                      isCall = false;
                      setState(() {});

                      if (giftCoins.length == 0) {
                        getCallDuration();
                      }
                    },
                    child: getTabItem('Gift coins', !isCall))
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 8,
            right: 8,
            child: Container(
              height: getSize(420),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: ColorConstants.borderColor,
                      style: BorderStyle.solid),
                  // color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8)),
              child: PageView(
                controller: pageController,
                onPageChanged: (val) {
                  currentIndex = val;
                  setState(() {});
                },
                children: [
                  getPageViewItem(),
                  getPageViewItem(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

//Page View Item
  getPageViewItem() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorConstants.red,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                getInfoTabItem("Nickname"),
                isCall == true ? getInfoTabItem("Mins") : SizedBox(),
                getInfoTabItem("Coins"),
              ],
            ),
          ),
        ),
        Container(
          height: getSize(384),
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return getListRow(
                    isCall == true ? callDuration[index] : giftCoins[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 1, color: ColorConstants.borderColor);
              },
              itemCount:
                  isCall == true ? callDuration.length : giftCoins.length),
        )
      ],
    );
  }

  getListRow(LeaderBoardModel item) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: isCall == true
                  ? (MathUtilities.screenWidth(context) - 34) / 3
                  : (MathUtilities.screenWidth(context) - 34) / 2,
              child: Center(
                child: Text(
                  item.name ?? "",
                  style: appTheme?.black14SemiBold
                      .copyWith(fontSize: getFontSize(12), color: Colors.white),
                ),
              ),
            ),
            isCall == true
                ? Container(
                    width: (MathUtilities.screenWidth(context) - 34) / 3,
                    child: Center(
                      child: Text(
                        item.callDuration.toString() + " mins",
                        style: appTheme?.black14SemiBold.copyWith(
                            fontSize: getFontSize(12), color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
            Container(
              width: isCall == true
                  ? (MathUtilities.screenWidth(context) - 34) / 3
                  : (MathUtilities.screenWidth(context) - 34) / 2,
              child: Center(
                child: Text(
                  (isCall == true
                          ? item.coins.toString()
                          : item.giftCoins.toString()) +
                      " Coins",
                  style: appTheme?.black14SemiBold.copyWith(
                      fontSize: getFontSize(12), color: ColorConstants.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Get Tab Item
  getInfoTabItem(String title) {
    return Container(
      width: isCall == true
          ? (MathUtilities.screenWidth(context) - 34) / 3
          : (MathUtilities.screenWidth(context) - 34) / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: appTheme?.black14SemiBold
                .copyWith(fontSize: getFontSize(12), color: Colors.black),
          ),
        ],
      ),
    );
  }

//Get Tab Item
  Widget getTabItem(String title, bool isCurrent) {
    return Container(
      width: MathUtilities.screenWidth(context) / 2,
      child: Column(
        children: [
          Text(
            title,
            style: appTheme?.black14SemiBold.copyWith(
                fontSize: getFontSize(16),
                color:
                    isCurrent == true ? ColorConstants.redText : Colors.white),
          ),
          SizedBox(
            height: getSize(12),
          ),
          Container(
              height: 1,
              color: isCurrent == true ? ColorConstants.redText : Colors.white,
              width: MathUtilities.screenWidth(context) / 2)
        ],
      ),
    );
  }
}
