import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      openVerificationPopUp();
      getCallDuration();
    });
  }

  openVerificationPopUp() {
    if (app.resolve<PrefUtils>().getUserDetails()?.isFacVerify == true) {
      return true;
    }

    showModalBottomSheet(
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
                                "Two Must-do before you become an official anchor",
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
                              NavigationUtilities.push(VerficationInvitation());
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
                                        Text("Unsubmitted",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: getFontSize(14),
                                                color: ColorConstants.red,
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

  getCallDuration() {
    Map<String, dynamic> req = {};
    req["callType"] = isCall == true ? "call" : "gift";
    req["agency_id"] = app.resolve<PrefUtils>().getUserDetails()?.agencyId ?? 0;

    NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.influeencerLeaderboard,
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();

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
        NetworkClient.getInstance.hideProgressDialog();
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
                getInfoTabItem("Ranking & Bonus"),
                getInfoTabItem("Nickname"),
                getInfoTabItem("Performance"),
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
              width: (MathUtilities.screenWidth(context) - 34) / 3,
              child: Center(
                child: Text(
                  "Bonus +" +
                      (isCall == true
                          ? item.coins.toString()
                          : item.giftCoins.toString()),
                  style: appTheme?.black14SemiBold.copyWith(
                      fontSize: getFontSize(12), color: ColorConstants.red),
                ),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - 34) / 3,
              child: Center(
                child: Text(
                  item.name ?? "",
                  style: appTheme?.black14SemiBold
                      .copyWith(fontSize: getFontSize(12), color: Colors.white),
                ),
              ),
            ),
            Container(
              width: (MathUtilities.screenWidth(context) - 35) / 3,
              child: Center(
                child: Text(
                  item.callDuration.toString() + " mins",
                  style: appTheme?.black14SemiBold
                      .copyWith(fontSize: getFontSize(12), color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Get Tab Item
  getInfoTabItem(String title) {
    return Container(
      width: (MathUtilities.screenWidth(context) - 34) / 3,
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
