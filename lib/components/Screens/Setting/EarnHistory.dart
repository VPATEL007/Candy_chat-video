import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ApiConstants.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/extensions/view.dart';
import 'package:video_chat/app/network/NetworkClient.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Leaderboard/LeaderBoardModel.dart';
import 'package:video_chat/components/Screens/Setting/income_report.dart';
import 'package:video_chat/components/widgets/CommanButton.dart';
import 'package:video_chat/provider/detail_earning_provider.dart';

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
  List<LeaderBoardModel> albumEarning = [];
  List<LeaderBoardModel> referralEarning = [];
  bool isCall = true;
  List<bool> isCurrent = [true, false, false, false];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getCallDuration();
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<DetailEarningProvider>(context, listen: false)
          .dailyDetailEarningReport(context, dateTime: '2022-07-14');
    });
  }

  resetSelectedState() {
    isCurrent = [false, false, false, false];
  }

  setIndexZero() {
    resetSelectedState();
    isCurrent[0] = true;
    currentIndex = 0;
  }

  setIndexOne() {
    resetSelectedState();
    isCurrent[1] = true;
    currentIndex = 1;
  }

  setIndexTwo() {
    resetSelectedState();
    isCurrent[2] = true;
    currentIndex = 2;
  }

  setIndexThree() {
    resetSelectedState();
    isCurrent[3] = true;
    currentIndex = 3;
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

          // var album = ;
          albumEarning =
              leaderBoardModelFromJson(jsonEncode(response["album"]));
          print(albumEarning[0].numberOfPurchase);
          referralEarning =
              leaderBoardModelFromJson(jsonEncode(response["refral"]));
          print(referralEarning[0].numberOfPurchase);
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
        appBar: getAppBarColor(context, 'Coins  ', 'details'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getSize(23),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getSize(25)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Album earning and Referral earning
                      InkWell(
                          onTap: () {
                            setIndexZero();
                            isCall = true;
                            setState(() {});
                            if (callDuration.length == 0) {
                              getCallDuration();
                            }
                          },
                          child: getTabItem('Video Call', 0, 2070)),
                      InkWell(
                          onTap: () {
                            setIndexOne();
                            isCall = false;
                            setState(() {});

                            if (giftCoins.length == 0) {
                              getCallDuration();
                            }
                          },
                          child: getTabItem('Gift', 1, 0)),
                      InkWell(
                          onTap: () {
                            setIndexTwo();
                            isCall = true;
                            setState(() {});

                            if (callDuration.length == 0) {
                              getCallDuration();
                            }
                          },
                          child: getTabItem('Match', 2, 295)),
                      InkWell(
                          onTap: () {
                            setIndexThree();
                            isCall = true;
                            setState(() {});

                            if (giftCoins.length == 0) {
                              getCallDuration();
                            }
                          },
                          child: getTabItem('Referral ', 3, 100))
                    ],
                  ),
                ),
              ),
              Container(
                  height: 1,
                  color: ColorConstants.redText,
                  width: MathUtilities.screenWidth(context)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(42), vertical: getSize(17)),
                child: Text(
                    'No coins earned if a video call ended in 30 seconds',
                    style: appTheme!.black16Bold.copyWith(
                        color: ColorConstants.colorPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(14))),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getSize(30)),
                child: Column(
                  children: [
                    Container(
                      width: MathUtilities.screenWidth(context),
                      alignment: Alignment.center,
                      height: getSize(57),
                      decoration: BoxDecoration(
                          color: ColorConstants.grayBackGround,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Text('07/09/2022',
                          style: appTheme!.black16Bold.copyWith(
                              color: ColorConstants.colorPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: getFontSize(14))),
                    ),
                    SizedBox(
                      height: getSize(7),
                    ),
                    // ListView.builder(
                    //   itemCount: ,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, index) {
                    //   return getPageViewItem(imgUrl: imgUrl, coin: coin, name: name, userID: userID, callDuration: callDuration, callType: callType);
                    // },),
                    SizedBox(
                      height: getSize(7),
                    ),
                    CommanButton(
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  getPageViewItem(
      {required String imgUrl,
      required int coin,
      required String name,
      required String userID,
      required int callDuration,
      required String callType}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: getSize(7)),
        width: MathUtilities.screenWidth(context),
        alignment: Alignment.center,
        height: getSize(90),
        decoration: BoxDecoration(
            color: ColorConstants.grayBackGround,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(
            horizontal: getSize(16), vertical: getSize(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  minRadius: getSize(15),
                  maxRadius: getSize(15),
                  backgroundImage: NetworkImage(imgUrl),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      icCoin,
                      height: getSize(16),
                    ),
                    SizedBox(
                      width: getSize(6),
                    ),
                    Text('$coin',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.colorPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: getFontSize(16)))
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: appTheme!.black16Bold.copyWith(
                        color: ColorConstants.colorPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: getFontSize(12))),
                Text('User ID: $userID',
                    style: appTheme!.black16Bold.copyWith(
                        color: ColorConstants.colorPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(10)))
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        text: 'Time:',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.colorPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                        children: [
                      TextSpan(
                        text: ' 14:21',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                      )
                    ])),
                RichText(
                    text: TextSpan(
                        text: 'Call Duration:',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.colorPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                        children: [
                      TextSpan(
                        text: '$callDuration',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                      )
                    ])),
                RichText(
                    text: TextSpan(
                        text: 'Call type:',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.colorPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                        children: [
                      TextSpan(
                        text: callType,
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                      )
                    ]))
              ],
            )
          ],
        ));
  }

  Widget rows() => Row(
        children: [
          getInfoTabItem("Date"),
          getInfoTabItem("Number of purchase"),
          getInfoTabItem("Coins"),
        ],
      );

  getListRow(LeaderBoardModel item, currentIndex) {
    print('coins==> ${item.coins} ${item.numberOfPurchase} $currentIndex');
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
                  DateFormat('d-M-y').format(DateTime.parse(item.date ?? '')),
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
                        currentIndex > 1
                            ? item.numberOfPurchase == null
                                ? '0'
                                : item.numberOfPurchase.toString()
                            : item.callDuration.toString() + " mins",
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
                  currentIndex > 1
                      ? item.coins == null
                          ? '0'
                          : item.coins.toString()
                      : "Coins " + item.earning.toString(),
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
      alignment: Alignment.center,
      width: isCall == true
          ? (MathUtilities.screenWidth(context) - 34) / 3
          : (MathUtilities.screenWidth(context) - 34) / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: appTheme?.black14SemiBold
                  .copyWith(fontSize: getFontSize(12), color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

//Get Tab Item
  Widget getTabItem(String title, index, int coin) {
    return Container(
      width: MathUtilities.screenWidth(context) / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: appTheme?.black14SemiBold.copyWith(
                fontSize: getFontSize(14),
                color: isCurrent[index] == true
                    ? ColorConstants.redText
                    : Colors.white),
          ),
          SizedBox(
            height: getSize(12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: getSize(5)),
                child: Image.asset(
                  icCoin,
                  height: getSize(10),
                ),
              ),
              Text('$coin',
                  style: appTheme!.black16Bold.copyWith(
                      color: ColorConstants.colorPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: getFontSize(14))),
            ],
          ),
          SizedBox(
            height: getSize(8),
          ),
          isCurrent[index] == true
              ? Container(
                  height: getSize(8),
                  decoration: BoxDecoration(
                      color: ColorConstants.red,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                )
              : SizedBox(
                  height: getSize(8),
                ),
        ],
      ),
    );
  }
}
