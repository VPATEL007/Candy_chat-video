import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/EnumConstant.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Leaderboard/LeaderBoardModel.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';

class EarnHistory extends StatefulWidget {
  EarnHistory({Key? key}) : super(key: key);

  @override
  State<EarnHistory> createState() => _EarnHistoryState();
}

class _EarnHistoryState extends State<EarnHistory> {
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;
  List<LeaderBoardModel> callDuration = [];
  List<LeaderBoardModel> giftCoins = [];
  bool isCall = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getCallDuration();
    });
  }

  getCallDuration() {
    Map<String, dynamic> req = {};
    // req["callType"] = isCall == true ? "call" : "gift";
    // req["agency_id"] = 10;

    NetworkClient.getInstance.showLoader(context);
    NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.influeencerEarningReport,
      params: req,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();

        if (response != null) {
          if (isCall) {
            var call = response["call"];
            callDuration =
                leaderBoardModelFromJson(jsonEncode(call["thisWeek"]));
            print("adasdasd");
          } else {
            var gift = response["gift"];
            giftCoins = leaderBoardModelFromJson(jsonEncode(gift["thisWeek"]));
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
      appBar: getAppBar(context, "Ranking",
          isWhite: false, leadingButton: getBackButton(context)),
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
              height: getSize(520),
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
                getInfoTabItem("Date"),
                isCall == true ? getInfoTabItem("Performance") : SizedBox(),
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
                  item.date ?? "",
                  style: appTheme?.black14SemiBold
                      .copyWith(fontSize: getFontSize(12), color: Colors.white),
                ),
              ),
            ),
            isCall == true
                ? Container(
                    width: isCall == true
                        ? (MathUtilities.screenWidth(context) - 34) / 3
                        : (MathUtilities.screenWidth(context) - 34) / 2,
                    child: Center(
                      child: Text(
                        item.callDuration.toString() + " mins",
                        style: appTheme?.black14SemiBold.copyWith(
                            fontSize: getFontSize(12), color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
            Container(
              width: isCall == true
                  ? (MathUtilities.screenWidth(context) - 34) / 3
                  : (MathUtilities.screenWidth(context) - 34) / 2,
              child: Center(
                child: Text(
                  "Coins " + item.earning.toString(),
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
