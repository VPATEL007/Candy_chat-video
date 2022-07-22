import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Screens/Setting/income_report.dart';
import 'package:video_chat/components/widgets/CommanButton.dart';
import 'package:video_chat/provider/detail_earning_provider.dart';

import '../../../app/utils/date_utils.dart';

class EarnHistory extends StatefulWidget {
  final String selectedDate;
  final int selectedIndex;

  EarnHistory(
      {Key? key, required this.selectedDate, required this.selectedIndex})
      : super(key: key);

  @override
  State<EarnHistory> createState() => _EarnHistoryState();
}

class _EarnHistoryState extends State<EarnHistory> {
  int currentIndex = 0;

  bool isCall = true;

  List<bool> isCurrent = [false, false, false, false, false];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.selectedIndex == 4 || widget.selectedIndex == 3
          ? scrollController?.animateTo(getSize(160),
              duration: Duration(milliseconds: 1000), curve: Curves.ease)
          : null;
      Provider.of<DetailEarningProvider>(context, listen: false)
          .dailyDetailEarningReport(context, dateTime: widget.selectedDate);
    });
    setState(() {
      currentIndex = widget.selectedIndex;
      isCurrent[widget.selectedIndex] = true;
    });
  }

  resetSelectedState() {
    isCurrent = [false, false, false, false, false];
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

  setIndexFour() {
    resetSelectedState();
    isCurrent[4] = true;
    currentIndex = 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.mainBgColor,
        appBar: getAppBarColor(context, 'Coins  ', 'details'),
        body: SingleChildScrollView(
          child: Consumer<DetailEarningProvider>(
            builder: (context, value, child) => Column(
              children: [
                SizedBox(
                  height: getSize(23),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getSize(25)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    child: Row(
                      children: [
                        // Album earning and Referral earning
                        InkWell(
                            onTap: () {
                              setIndexZero();
                              isCall = true;
                              value.dailyDetailEarningReport(context,
                                  dateTime: widget.selectedDate);
                              setState(() {});
                            },
                            child: getTabItem(
                                'Video Call',
                                0,
                                value.detailEarningReportModel?.vidocall
                                        ?.total ??
                                    0)),
                        InkWell(
                            onTap: () {
                              setIndexOne();
                              isCall = false;
                              value.dailyDetailEarningReport(context,
                                  dateTime: widget.selectedDate);
                              setState(() {});
                            },
                            child: getTabItem(
                                'Gift',
                                1,
                                value.detailEarningReportModel?.gifts?.total ??
                                    0)),
                        InkWell(
                            onTap: () {
                              setIndexTwo();
                              isCall = true;
                              value.dailyDetailEarningReport(context,
                                  dateTime: widget.selectedDate);
                              setState(() {});
                            },
                            child: getTabItem(
                                'Match',
                                2,
                                value.detailEarningReportModel?.match?.total ??
                                    0)),
                        InkWell(
                            onTap: () {
                              setIndexThree();
                              isCall = true;
                              value.dailyDetailEarningReport(context,
                                  dateTime: widget.selectedDate);
                              setState(() {});
                            },
                            child: getTabItem(
                                'Referral ',
                                3,
                                value.detailEarningReportModel?.refral?.total ??
                                    0)),
                        InkWell(
                            onTap: () {
                              setIndexFour();
                              isCall = true;
                              value.dailyDetailEarningReport(context,
                                  dateTime: widget.selectedDate);
                              setState(() {});
                            },
                            child: getTabItem(
                                'Albums ',
                                4,
                                value.detailEarningReportModel?.albums?.total ??
                                    0))
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
                        child: Text(widget.selectedDate.substring(0, 10),
                            style: appTheme!.black16Bold.copyWith(
                                color: ColorConstants.colorPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: getFontSize(14))),
                      ),
                      SizedBox(
                        height: getSize(7),
                      ),
                      SizedBox(
                        height: 350,
                        child: currentIndex == 0
                            ? ListView.builder(
                                itemCount: value.detailEarningReportModel
                                    ?.vidocall?.details?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return getPageViewItem(
                                      time: DateUtilities()
                                          .convertServerDateToFormatterString(value.detailEarningReportModel?.vidocall?.details![index].time ?? '',
                                              formatter: DateUtilities.h_mm_a),
                                      isShowTwoField: true,
                                      imgUrl: value
                                              .detailEarningReportModel
                                              ?.vidocall
                                              ?.details![index]
                                              .user
                                              ?.photoUrl ??
                                          '',
                                      coin: value
                                              .detailEarningReportModel
                                              ?.vidocall
                                              ?.details![index]
                                              .coin ??
                                          0,
                                      name: value
                                              .detailEarningReportModel
                                              ?.vidocall
                                              ?.details![index]
                                              .user
                                              ?.userName ??
                                          '',
                                      userID: value
                                              .detailEarningReportModel
                                              ?.vidocall
                                              ?.details![index]
                                              .user
                                              ?.id ??
                                          0,
                                      callDurations: value.detailEarningReportModel?.vidocall?.details?[index].callDuration ?? 0,
                                      callType: value.detailEarningReportModel?.vidocall?.details?[index].calltype ?? '');
                                },
                              )
                            : ListView.builder(
                                itemCount: currentIndex == 1
                                    ? value.detailEarningReportModel?.gifts
                                        ?.details?.length
                                    : currentIndex == 2
                                        ? value.detailEarningReportModel?.match
                                            ?.details?.length
                                        : currentIndex == 3
                                            ? value.detailEarningReportModel
                                                ?.refral?.details?.length
                                            : value.detailEarningReportModel
                                                ?.albums?.details?.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return getPageViewItem(
                                    isShowTwoField: false,
                                    time: currentIndex == 1
                                        ? DateUtilities().convertServerDateToFormatterString(
                                            value.detailEarningReportModel?.gifts?.details![index].time ??
                                                '',
                                            formatter: DateUtilities.h_mm_a)
                                        : currentIndex == 2
                                            ? DateUtilities().convertServerDateToFormatterString(
                                                value
                                                        .detailEarningReportModel
                                                        ?.match
                                                        ?.details![index]
                                                        .time ??
                                                    '',
                                                formatter: DateUtilities.h_mm_a)
                                            : currentIndex == 3
                                                ? DateUtilities().convertServerDateToFormatterString(
                                                    value
                                                            .detailEarningReportModel
                                                            ?.refral
                                                            ?.details![index]
                                                            .time ??
                                                        '',
                                                    formatter:
                                                        DateUtilities.h_mm_a)
                                                : DateUtilities().convertServerDateToFormatterString(
                                                    value.detailEarningReportModel?.albums?.details![index].time ?? '',
                                                    formatter: DateUtilities.h_mm_a),
                                    imgUrl: currentIndex == 1
                                        ? value
                                                .detailEarningReportModel
                                                ?.gifts
                                                ?.details![index]
                                                .user
                                                ?.photoUrl ??
                                            ''
                                        : currentIndex == 2
                                            ? value
                                                    .detailEarningReportModel
                                                    ?.match
                                                    ?.details![index]
                                                    .user
                                                    ?.photoUrl ??
                                                ''
                                            : currentIndex == 3
                                                ? value
                                                        .detailEarningReportModel
                                                        ?.refral
                                                        ?.details![index]
                                                        .user
                                                        ?.photoUrl ??
                                                    ''
                                                : value
                                                        .detailEarningReportModel
                                                        ?.albums
                                                        ?.details![index]
                                                        .user
                                                        ?.photoUrl ??
                                                    '',
                                    coin: currentIndex == 1
                                        ? value.detailEarningReportModel?.gifts
                                                ?.details![index].coin ??
                                            0
                                        : currentIndex == 2
                                            ? value
                                                    .detailEarningReportModel
                                                    ?.match
                                                    ?.details![index]
                                                    .coin ??
                                                0
                                            : currentIndex == 3
                                                ? value
                                                        .detailEarningReportModel
                                                        ?.refral
                                                        ?.details![index]
                                                        .coin ??
                                                    0
                                                : value
                                                        .detailEarningReportModel
                                                        ?.albums
                                                        ?.details![index]
                                                        .coin ??
                                                    0,
                                    name: currentIndex == 1
                                        ? value
                                                .detailEarningReportModel
                                                ?.gifts
                                                ?.details![index]
                                                .user
                                                ?.userName ??
                                            ''
                                        : currentIndex == 2
                                            ? value
                                                    .detailEarningReportModel
                                                    ?.match
                                                    ?.details![index]
                                                    .user
                                                    ?.userName ??
                                                ''
                                            : currentIndex == 3
                                                ? value
                                                        .detailEarningReportModel
                                                        ?.refral
                                                        ?.details![index]
                                                        .user
                                                        ?.userName ??
                                                    ''
                                                : value
                                                        .detailEarningReportModel
                                                        ?.albums
                                                        ?.details![index]
                                                        .user
                                                        ?.userName ??
                                                    '',
                                    userID: currentIndex == 1
                                        ? value.detailEarningReportModel?.gifts
                                                ?.details![index].user?.id ??
                                            0
                                        : currentIndex == 2
                                            ? value
                                                    .detailEarningReportModel
                                                    ?.match
                                                    ?.details![index]
                                                    .user
                                                    ?.id ??
                                                0
                                            : currentIndex == 3
                                                ? value
                                                        .detailEarningReportModel
                                                        ?.refral
                                                        ?.details![index]
                                                        .user
                                                        ?.id ??
                                                    0
                                                : value
                                                        .detailEarningReportModel
                                                        ?.refral
                                                        ?.details![index]
                                                        .user
                                                        ?.id ??
                                                    0,
                                  );
                                },
                              ),
                      ),
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
          ),
        ));
  }

  getPageViewItem({
    required String imgUrl,
    required int coin,
    bool isShowTwoField = false,
    required String name,
    required int userID,
    int? callDurations,
    required String time,
    String? callType,
  }) {
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
                  backgroundColor: Colors.transparent,
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
            SizedBox(
              width: getSize(10),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: appTheme!.black16Bold.copyWith(
                          color: ColorConstants.colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: getFontSize(12))),
                  SizedBox(
                    height: getSize(5),
                  ),
                  Text('User ID: $userID',
                      style: appTheme!.black16Bold.copyWith(
                          color: ColorConstants.colorPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(10)))
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        text: 'Time : ',
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.colorPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                        children: [
                      TextSpan(
                        text: time,
                        style: appTheme!.black16Bold.copyWith(
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w500,
                            fontSize: getFontSize(12)),
                      )
                    ])),
                isShowTwoField
                    ? RichText(
                        text: TextSpan(
                            text: 'Call Duration : ',
                            style: appTheme!.black16Bold.copyWith(
                                color: ColorConstants.colorPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: getFontSize(12)),
                            children: [
                            TextSpan(
                              text: '$callDurations',
                              style: appTheme!.black16Bold.copyWith(
                                  color: ColorConstants.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: getFontSize(12)),
                            )
                          ]))
                    : SizedBox(),
                isShowTwoField
                    ? RichText(
                        text: TextSpan(
                            text: 'Call type : ',
                            style: appTheme!.black16Bold.copyWith(
                                color: ColorConstants.colorPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: getFontSize(12)),
                            children: [
                            TextSpan(
                              text: callType ?? '',
                              style: appTheme!.black16Bold.copyWith(
                                  color: ColorConstants.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: getFontSize(12)),
                            )
                          ]))
                    : SizedBox()
              ],
            )
          ],
        ));
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
