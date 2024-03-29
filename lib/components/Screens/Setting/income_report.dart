import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Setting/EarnHistory.dart';
import 'package:video_chat/components/Screens/Setting/salary_generation.dart';
import 'package:video_chat/components/widgets/CommanButton.dart';
import 'package:video_chat/provider/income_report_provider.dart';

import '../../../provider/followes_provider.dart';

class IncomeReport extends StatefulWidget {
  const IncomeReport({Key? key}) : super(key: key);

  @override
  State<IncomeReport> createState() => _IncomeReportState();
}

class _IncomeReportState extends State<IncomeReport> {
  bool isWeeklySelected = false;
  int? selectedIndex;
  int? selectedWeeklyIndex;
  FreshchatUser? freshchatUser;
  final GlobalKey<ScaffoldState>? _scaffoldKey = new GlobalKey<ScaffoldState>();

  late int todayIndex;

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;

    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  List sundayIndex = [];
  List<List> finalList = [];
  ScrollController? scrollController = ScrollController();

  String? formatted;
  String? date;
  String? monthFormatted;
  String? month;

  sunDayWeeklyList() {
    List dataList = List.generate(
        daysInRange.call(DateTime(2022, 07, 05), DateTime(2023)).length,
        (index) =>
            daysInRange.call(DateTime(2022, 07, 05), DateTime(2023))[index]);

    for (int i = 0; i < dataList.length; i++) {
      final DateFormat formatter = DateFormat('E');
      final formatteds = formatter.format(dataList[i]);

      final DateFormat monthYearFormat = DateFormat('yMMMM');
      monthFormatted = monthYearFormat.format(DateTime.now());
      if (formatteds == 'Mon') {
        finalList.add(sundayIndex.toSet().toList());
        sundayIndex.clear();
        sundayIndex.add(daysInRange
            .call(DateTime(2022, 07, 05), DateTime(2023))[i]
            .toIso8601String()
            .substring(0, 10));
        finalList.add([dataList[i]]);
      } else {
        finalList.add([dataList[i]]);
        sundayIndex.add(daysInRange
            .call(DateTime(2022, 07, 05), DateTime(2023))[i]
            .toIso8601String()
            .substring(0, 10));
      }
    }
  }

  void registerFcmToken() async {
    if (Platform.isAndroid) {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token is generated $token");
      Freshchat.setPushRegistrationToken(token!);
    }
  }

  void notifyRestoreId(var event) async {
    FreshchatUser user = await Freshchat.getUser;
    String? restoreId = user.getRestoreId();
    if (restoreId != null) {
      Clipboard.setData(new ClipboardData(text: restoreId));
    }
    _scaffoldKey!.currentState!.showSnackBar(
        new SnackBar(content: new Text("Restore ID copied: $restoreId")));
  }

  void handleFreshchatNotification(Map<String, dynamic> message) async {
    if (await Freshchat.isFreshchatNotification(message)) {
      print("is Freshchat notification");
      Freshchat.handlePushNotification(message);
    }
  }

  Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
    print("Inside background handler");
    handleFreshchatNotification(message.data);
  }

  @override
  void initState() {
    sunDayWeeklyList();
    DateTime datetime = DateTime.now();
    int todayindex = finalList.indexWhere((element) =>
        element.join().substring(0, 10) ==
        datetime.toIso8601String().substring(0, 10));
    setState(() {
      todayIndex = todayindex;
      selectedIndex = todayIndex;
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      double _position = todayIndex.toDouble() * (getSize(42));
      setState(() {
        scrollController?.animateTo(_position,
            duration: Duration(milliseconds: 1000), curve: Curves.ease);
      });
      Freshchat.init(FRESH_CHAT_APP_ID, FRESH_CHAT_APP_KEY, FRESH_CHAT_DOMAIN);
      var restoreStream = Freshchat.onRestoreIdGenerated;
      var restoreStreamSubsctiption = restoreStream.listen((event) {
        print("Restore ID Generated: $event");
        notifyRestoreId(event);
      });

      var unreadCountStream = Freshchat.onMessageCountUpdate;
      unreadCountStream.listen((event) {
        print("Have unread messages: $event");
      });

      var userInteractionStream = Freshchat.onUserInteraction;
      userInteractionStream.listen((event) {
        print("User interaction for Freshchat SDK");
      });

      if (Platform.isAndroid) {
        registerFcmToken();
        FirebaseMessaging.instance.onTokenRefresh
            .listen(Freshchat.setPushRegistrationToken);

        Freshchat.setNotificationConfig(notificationInterceptionEnabled: true);
        var notificationInterceptStream = Freshchat.onNotificationIntercept;
        notificationInterceptStream.listen((event) {
          print("Freshchat Notification Intercept detected");
          Freshchat.openFreshchatDeeplink(event["url"]);
        });

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          var data = message.data;
          handleFreshchatNotification(data);
          print("Notification Content: $data");
        });
        FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
      }
      Provider.of<DailyEarningDetailProvider>(context, listen: false)
          .dailyEarningReport(context,
              dateTime: DateTime.now().toIso8601String().substring(0, 10));
      Provider.of<DailyEarningDetailProvider>(context, listen: false)
          .salaryDetails(context);
    });
    super.initState();
  }

  String selectedDate = DateTime.now().toIso8601String();
  String weeklySelectedFirstDate = DateTime.now().toIso8601String();
  String weeklySelectedEndDate = DateTime.now().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      appBar: getAppBarColor(context, 'Income ', 'report'),
      body: SingleChildScrollView(
        child: Consumer<DailyEarningDetailProvider>(
          builder: (context, value, child) => Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getSize(30), vertical: getSize(18)),
                    child: Text(
                      monthFormatted ?? '',
                      style: appTheme!.black16Bold.copyWith(
                          color: ColorConstants.red,
                          fontWeight: FontWeight.w600,
                          fontSize: getFontSize(14)),
                    ),
                  ),
                  SizedBox(
                    width: MathUtilities.screenWidth(context),
                    height: 78,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: finalList.length,
                      itemBuilder: (context, index) {
                        if (finalList[index]
                            .join()
                            .substring(11, 13)
                            .startsWith('00')) {
                          date = finalList[index].join();

                          var parsedDate = DateTime.parse(date!);
                          final DateFormat formatter = DateFormat('E');
                          formatted = formatter.format(parsedDate);

                          final DateFormat formatter2 = DateFormat('M');
                          month = formatter2.format(parsedDate);
                        } else {}
                        return finalList[index]
                                .join()
                                .substring(11, 13)
                                .startsWith('00')
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final DateFormat monthYearFormat =
                                        DateFormat('yMMMM');
                                    monthFormatted = monthYearFormat.format(
                                        DateTime.parse(
                                            finalList[index].join()));
                                    selectedIndex = index;
                                    selectedDate = finalList[index].join();
                                    isWeeklySelected = false;
                                    Provider.of<DailyEarningDetailProvider>(
                                            context,
                                            listen: false)
                                        .dailyEarningReport(context,
                                            dateTime:
                                                selectedDate.substring(0, 10));
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: selectedIndex == index &&
                                                  isWeeklySelected == false
                                              ? getSize(10)
                                              : 0),
                                      width: selectedIndex == index &&
                                              isWeeklySelected == false
                                          ? getSize(38)
                                          : null,
                                      height: selectedIndex == index &&
                                              isWeeklySelected == false
                                          ? getSize(33)
                                          : getSize(30),
                                      decoration: BoxDecoration(
                                          color: selectedIndex == index &&
                                                  isWeeklySelected == false
                                              ? ColorConstants.red
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: selectedIndex ==
                                                        index &&
                                                    isWeeklySelected == false
                                                ? getSize(5)
                                                : getSize(10),
                                            vertical: selectedIndex == index &&
                                                    isWeeklySelected == false
                                                ? getSize(3)
                                                : 0),
                                        child: Text(
                                          formatted ?? '',
                                          style: appTheme!.black16Bold.copyWith(
                                              color: selectedIndex == index &&
                                                      isWeeklySelected == false
                                                  ? ColorConstants.mainBgColor
                                                  : ColorConstants
                                                      .calenderGreyColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(11)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: selectedIndex == index &&
                                              isWeeklySelected == false
                                          ? getSize(1)
                                          : getSize(18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: selectedIndex == index &&
                                                  isWeeklySelected == false
                                              ? getSize(10)
                                              : 0),
                                      alignment: selectedIndex == index &&
                                              isWeeklySelected == false
                                          ? Alignment.bottomCenter
                                          : null,
                                      width: selectedIndex == index &&
                                              isWeeklySelected == false
                                          ? getSize(38)
                                          : null,
                                      height: selectedIndex == index &&
                                              isWeeklySelected == false
                                          ? getSize(33)
                                          : getSize(30),
                                      decoration: BoxDecoration(
                                          color: selectedIndex == index &&
                                                  isWeeklySelected == false
                                              ? ColorConstants.red
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: selectedIndex ==
                                                        index &&
                                                    isWeeklySelected == false
                                                ? getSize(5)
                                                : getSize(10),
                                            vertical: selectedIndex == index &&
                                                    isWeeklySelected == false
                                                ? getSize(3)
                                                : 0),
                                        child: Text(
                                          '${date?.substring(8, 10)}',
                                          style: appTheme!.black16Bold.copyWith(
                                              color: selectedIndex == index &&
                                                      isWeeklySelected == false
                                                  ? ColorConstants.mainBgColor
                                                  : ColorConstants
                                                      .calenderGreyColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(12)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final DateFormat monthYearFormat =
                                        DateFormat('yMMMM');
                                    monthFormatted = monthYearFormat.format(
                                        DateTime.parse(finalList[index].last));
                                    weeklySelectedFirstDate =
                                        finalList[index].first;
                                    weeklySelectedEndDate =
                                        finalList[index].last;
                                    selectedWeeklyIndex = index;
                                    isWeeklySelected = true;
                                    WidgetsBinding.instance
                                        ?.addPostFrameCallback((_) {
                                      Provider.of<DailyEarningDetailProvider>(
                                              context,
                                              listen: false)
                                          .weeklyEarningReport(context,
                                              startDate: finalList[index].first,
                                              endDate: finalList[index].last);
                                      Provider.of<DailyEarningDetailProvider>(
                                              context,
                                              listen: false)
                                          .salaryDetails(context,
                                              fromDate:
                                                  '${finalList[index].first}');
                                    });
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              selectedWeeklyIndex == index &&
                                                      isWeeklySelected
                                                  ? getSize(10)
                                                  : 0),
                                      width: selectedWeeklyIndex == index &&
                                              isWeeklySelected
                                          ? getSize(72)
                                          : null,
                                      height: selectedWeeklyIndex == index &&
                                              isWeeklySelected
                                          ? getSize(33)
                                          : getSize(30),
                                      decoration: BoxDecoration(
                                          color: selectedWeeklyIndex == index &&
                                                  isWeeklySelected
                                              ? ColorConstants.red
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                selectedWeeklyIndex == index &&
                                                        isWeeklySelected
                                                    ? getSize(5)
                                                    : getSize(10),
                                            vertical:
                                                selectedWeeklyIndex == index &&
                                                        isWeeklySelected
                                                    ? getSize(3)
                                                    : 0),
                                        child: Text(
                                          'Weekly',
                                          style: appTheme!.black16Bold.copyWith(
                                              color: selectedWeeklyIndex ==
                                                          index &&
                                                      isWeeklySelected
                                                  ? ColorConstants.mainBgColor
                                                  : ColorConstants
                                                      .calenderGreyColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(11)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: selectedWeeklyIndex == index &&
                                              isWeeklySelected
                                          ? getSize(1)
                                          : getSize(18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              selectedWeeklyIndex == index &&
                                                      isWeeklySelected
                                                  ? getSize(10)
                                                  : 0),
                                      alignment: selectedWeeklyIndex == index &&
                                              isWeeklySelected
                                          ? Alignment.bottomCenter
                                          : null,
                                      width: selectedWeeklyIndex == index &&
                                              isWeeklySelected
                                          ? getSize(72)
                                          : null,
                                      height: selectedWeeklyIndex == index &&
                                              isWeeklySelected
                                          ? getSize(33)
                                          : getSize(30),
                                      decoration: BoxDecoration(
                                          color: selectedWeeklyIndex == index &&
                                                  isWeeklySelected
                                              ? ColorConstants.red
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                selectedWeeklyIndex == index &&
                                                        isWeeklySelected
                                                    ? getSize(5)
                                                    : getSize(10),
                                            vertical:
                                                selectedWeeklyIndex == index &&
                                                        isWeeklySelected
                                                    ? getSize(3)
                                                    : 0),
                                        child: Text(
                                          '$month/${finalList[index].first.substring(8, 10)} $month/${finalList[index].last.substring(8, 10)}',
                                          style: appTheme!.black16Bold.copyWith(
                                              color: selectedWeeklyIndex ==
                                                          index &&
                                                      isWeeklySelected
                                                  ? ColorConstants.mainBgColor
                                                  : ColorConstants
                                                      .calenderGreyColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(12)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                color: ColorConstants.red,
                height: 1,
              ),
              isWeeklySelected
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: getSize(20)),
                          child: Text(
                            'Salary settlement progress',
                            style: appTheme?.black16Bold.copyWith(
                                fontWeight: FontWeight.w700,
                                color: ColorConstants.bgColor,
                                fontSize: getFontSize(14)),
                          ),
                        ),
                        getStepProgressIndicator(
                            context, value.salaryDetailModel?.status ?? ''),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SalaryGeneration(
                                    firstDate: weeklySelectedFirstDate,
                                    endDate: weeklySelectedEndDate);
                              },
                            ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: getSize(8)),
                            width: MathUtilities.screenWidth(context) * 0.90,
                            decoration: BoxDecoration(
                                color: ColorConstants.grayBackGround,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              text: 'Total income\t\t\t',
                                              style: appTheme?.black16Bold
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ColorConstants
                                                          .bgColor,
                                                      fontSize:
                                                          getFontSize(14)),
                                              children: [
                                            TextSpan(
                                                text:
                                                    '\t--\t${value.salaryDetailModel?.totalIncome}',
                                                style: appTheme?.black16Bold
                                                    .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorConstants.bgColor,
                                                  fontStyle: FontStyle.italic,
                                                ))
                                          ])),
                                      SizedBox(width: getSize(5)),
                                      CircleAvatar(
                                        minRadius: getSize(8),
                                        maxRadius: getSize(8),
                                        backgroundColor:
                                            ColorConstants.calenderGreyColor,
                                        child: Icon(Icons.question_mark_rounded,
                                            color:
                                                ColorConstants.grayBackGround,
                                            size: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: MathUtilities.screenWidth(context),
                                  color: ColorConstants.greyC4Color
                                      .withOpacity(0.60),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(20),
                                      horizontal: getSize(17)),
                                  child: Row(
                                    children: [
                                      Text('Salary',
                                          style: appTheme?.black16Bold.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstants.bgColor,
                                              fontSize: getFontSize(14))),
                                      SizedBox(width: getSize(8)),
                                      CircleAvatar(
                                        minRadius: getSize(8),
                                        maxRadius: getSize(8),
                                        backgroundColor:
                                            ColorConstants.calenderGreyColor,
                                        child: Icon(Icons.question_mark_rounded,
                                            color:
                                                ColorConstants.grayBackGround,
                                            size: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                          '--${value.salaryDetailModel?.salary}',
                                          style: appTheme?.black16Bold.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: ColorConstants.bgColor,
                                              fontSize: getFontSize(14))),
                                      SizedBox(width: getSize(20))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: MathUtilities.screenWidth(context),
                                  color: ColorConstants.greyC4Color
                                      .withOpacity(0.60),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(20),
                                      horizontal: getSize(17)),
                                  child: Row(children: [
                                    Text('Your level',
                                        style: appTheme?.black16Bold.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstants.bgColor,
                                            fontSize: getFontSize(14))),
                                    const Spacer(),
                                    Image.asset(winIcon, width: getSize(30)),
                                    SizedBox(width: getSize(20))
                                  ]),
                                ),
                                Container(
                                  height: 1,
                                  width: MathUtilities.screenWidth(context),
                                  color: ColorConstants.greyC4Color
                                      .withOpacity(0.60),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(20),
                                      horizontal: getSize(17)),
                                  child: Row(
                                    children: [
                                      Text('Coins rate ',
                                          style: appTheme?.black16Bold.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstants.bgColor,
                                              fontSize: getFontSize(14))),
                                      SizedBox(width: getSize(5)),
                                      CircleAvatar(
                                        minRadius: getSize(8),
                                        maxRadius: getSize(8),
                                        backgroundColor:
                                            ColorConstants.calenderGreyColor,
                                        child: Icon(Icons.question_mark_rounded,
                                            color:
                                                ColorConstants.grayBackGround,
                                            size: 12),
                                      ),
                                      const Spacer(),
                                      Image.asset(icCoin, width: getSize(10)),
                                      Text(
                                          ' ${value.salaryDetailModel?.coinValue} = ${value.salaryDetailModel?.currecy.toUpperCase()}',
                                          style: appTheme?.black16Bold.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: ColorConstants.bgColor,
                                              fontSize: getFontSize(14))),
                                      SizedBox(width: getSize(20))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: MathUtilities.screenWidth(context),
                                  color: ColorConstants.greyC4Color
                                      .withOpacity(0.60),
                                ),
                                SizedBox(height: getSize(15))
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        getTitle(
                            totalCoin:
                                value.dailyEarningReportModel?.totalCoins ?? 0),
                        getBox(
                          context: context,
                          title: 'Video call coins',
                          onTap: () {
                            NavigationUtilities.push(EarnHistory(
                                selectedIndex: 0,
                                selectedDate: selectedDate.substring(0, 10)));
                          },
                          coin: value.dailyEarningReportModel?.videoCallCoins ??
                              0,
                        ),
                        getBox(
                            context: context,
                            title: 'Gifts coins',
                            coin: value.dailyEarningReportModel?.giftsCoin ?? 0,
                            onTap: () {
                              NavigationUtilities.push(EarnHistory(
                                  selectedIndex: 1,
                                  selectedDate: selectedDate.substring(0, 10)));
                            }),
                        getBox(
                            context: context,
                            title: 'Match total',
                            onTap: () {
                              NavigationUtilities.push(EarnHistory(
                                  selectedIndex: 2,
                                  selectedDate: selectedDate.substring(0, 10)));
                            },
                            coin:
                                value.dailyEarningReportModel?.matchCoin ?? 0),
                        getBox(
                            context: context,
                            onTap: () {
                              NavigationUtilities.push(EarnHistory(
                                  selectedIndex: 3,
                                  selectedDate: selectedDate.substring(0, 10)));
                            },
                            title: 'Referral Coins',
                            coin: value.dailyEarningReportModel?.refralCoins ??
                                0),
                        getBox(
                            context: context,
                            title: 'Albums coins',
                            onTap: () {
                              NavigationUtilities.push(EarnHistory(
                                  selectedIndex: 4,
                                  selectedDate: selectedDate.substring(0, 10)));
                            },
                            coin:
                                value.dailyEarningReportModel?.albumCoin ?? 0),
                        getBox(
                            context: context,
                            title: 'Daily video call duration',
                            coin: 0,
                            isDuration: true,
                            duration: value.dailyEarningReportModel
                                    ?.weeklyCallDuration ??
                                ''),
                      ],
                    ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(60), vertical: getSize(17)),
                child: Text(
                    'The income report data above takes UTC +2 as standard',
                    textAlign: TextAlign.center,
                    style: appTheme!.black16Bold.copyWith(
                        color: ColorConstants.colorPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(14))),
              ),
              CommanButton(
                onTap: () async {
                  Freshchat.showConversations();
                  UserModel? userModel =
                      Provider.of<FollowesProvider>(context, listen: false)
                          .userModel;
                  Freshchat.setUser(
                      email: userModel?.email ?? '',
                      firstName: userModel?.userName ?? '',
                      phonNumber: userModel?.phone ?? '',
                      lastName: '');
                },
              ),
              SizedBox(
                height: getSize(20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // get Income Button Weekly Text
  Widget getIncomeButtonText(
      {required String title,
      int? title2,
      bool isDownArrow = false,
      bool isCoinIcon = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getSize(17), vertical: getSize(20)),
          child: Row(
            children: [
              getTitleText(title: title),
              Spacer(),
              isCoinIcon
                  ? Row(
                      children: [
                        Image.asset(
                          icCoin,
                          width: getSize(10),
                        ),
                        SizedBox(
                          width: getSize(5),
                        ),
                        Text('$title2 = USD',
                            style: appTheme!.black16Bold.copyWith(
                                color: ColorConstants.colorPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: getFontSize(14)))
                      ],
                    )
                  : Text('$title2',
                      style: appTheme!.black16Bold.copyWith(
                          color: ColorConstants.colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: getFontSize(14))),
              isDownArrow
                  ? Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorConstants.red,
                    )
                  : SizedBox(
                      width: getSize(27),
                    )
            ],
          ),
        ),
        Container(
            height: 1, color: ColorConstants.greyC4Color.withOpacity(0.60)),
      ],
    );
  }

  // getTitle Text
  Widget getTitleText(
      {required String title, bool isUsdText = false, int? totalIncome}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: appTheme!.black16Bold.copyWith(
                color: ColorConstants.colorPrimary,
                fontWeight: FontWeight.w500,
                fontSize: getFontSize(14))),
        SizedBox(
          width: isUsdText ? getSize(10) : 0,
        ),
        isUsdText
            ? Text('$totalIncome',
                style: appTheme!.black16Bold.copyWith(
                    color: ColorConstants.colorPrimary,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: getFontSize(16)))
            : SizedBox(),
        SizedBox(
          width: getSize(5),
        ),
        Icon(
          Icons.help,
          size: getSize(22),
          color: ColorConstants.calenderGreyColor,
        )
      ],
    );
  }

  // getTitle
  Widget getTitle({required int totalCoin}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getSize(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Total coins',
              style: appTheme!.black16Bold.copyWith(
                  color: ColorConstants.red,
                  fontWeight: FontWeight.bold,
                  fontSize: getFontSize(14))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(10)),
            child: Image.asset(
              icCoin,
              height: getSize(10),
            ),
          ),
          Text('$totalCoin',
              style: appTheme!.black16Bold.copyWith(
                  color: ColorConstants.colorPrimary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  fontSize: getFontSize(20))),
          GestureDetector(
            onTap: () async {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    "Total coins is sum of all the coins earned",
                    style: appTheme?.black16Bold
                        .copyWith(fontSize: getFontSize(14)),
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getSize(12)),
              child: Image.asset(
                questionIcon,
                height: getSize(19),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Table Calender

  // Income Report Box
  Widget getBox(
      {required BuildContext context,
      required String title,
      required int coin,
      String? duration,
      Function()? onTap,
      bool isDuration = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: getSize(8)),
        width: MathUtilities.screenWidth(context) * 0.90,
        height: getSize(60),
        decoration: BoxDecoration(
            color: ColorConstants.grayBackGround,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: getSize(17)),
        child: Row(
          children: [
            Text(title,
                style: appTheme!.black16Bold.copyWith(
                    color: ColorConstants.colorPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: getFontSize(14))),
            const Spacer(),
            isDuration
                ? Text(duration!,
                    style: appTheme!.black16Bold.copyWith(
                        color: ColorConstants.colorPrimary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        fontSize: getFontSize(14)))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: getSize(5)),
                    child: Image.asset(
                      icCoin,
                      height: getSize(10),
                    ),
                  ),
            isDuration
                ? SizedBox()
                : Text('$coin',
                    style: appTheme!.black16Bold.copyWith(
                        color: ColorConstants.colorPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: getFontSize(14))),
            isDuration
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.only(left: getSize(7)),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.red,
                      size: getSize(17),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

// Strp Progress Indicator
getStepProgressIndicator(BuildContext context, String type) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            minRadius: getSize(13),
            maxRadius: getSize(13),
            backgroundColor: (type.toUpperCase() == 'GENERATED' ||
                    type.toUpperCase() == 'APPROVED')
                ? ColorConstants.red
                : ColorConstants.calenderGreyColor,
            child: (type.toUpperCase() == 'GENERATED' ||
                    type.toUpperCase() == 'APPROVED')
                ? CircleAvatar(
                    minRadius: getSize(7),
                    maxRadius: getSize(7),
                    backgroundColor: ColorConstants.colorPrimary,
                  )
                : const SizedBox(),
          ),
          Container(
            height: 1,
            width: MathUtilities.screenWidth(context) / 4,
            color: ColorConstants.colorPrimary,
          ),
          CircleAvatar(
            minRadius: getSize(13),
            maxRadius: getSize(13),
            backgroundColor: (type.toUpperCase() == 'APPROVED' ||
                    type.toUpperCase() == 'PAID')
                ? ColorConstants.red
                : ColorConstants.calenderGreyColor,
            child: (type.toUpperCase() == 'APPROVED' ||
                    type.toUpperCase() == 'PAID')
                ? CircleAvatar(
                    minRadius: getSize(7),
                    maxRadius: getSize(7),
                    backgroundColor: ColorConstants.colorPrimary,
                  )
                : const SizedBox(),
          ),
          Container(
            height: 1,
            width: MathUtilities.screenWidth(context) / 4,
            color: ColorConstants.colorPrimary,
          ),
          CircleAvatar(
            minRadius: getSize(13),
            maxRadius: getSize(13),
            backgroundColor: type.toUpperCase() == 'PAID'
                ? ColorConstants.red
                : ColorConstants.calenderGreyColor,
            child: type.toUpperCase() == 'PAID'
                ? CircleAvatar(
                    minRadius: getSize(7),
                    maxRadius: getSize(7),
                    backgroundColor: ColorConstants.colorPrimary,
                  )
                : const SizedBox(),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(45), vertical: getSize(10)),
        child: Row(
          children: [
            Text('Generated',
                style: appTheme!.black16Bold.copyWith(
                    color: ColorConstants.red,
                    fontWeight: FontWeight.w600,
                    fontSize: getFontSize(10))),
            SizedBox(
              width: MathUtilities.screenWidth(context) / 5,
            ),
            Text('Approved',
                style: appTheme!.black16Bold.copyWith(
                    color: ColorConstants.calenderGreyColor,
                    fontWeight: FontWeight.w600,
                    fontSize: getFontSize(10))),
            SizedBox(
              width: MathUtilities.screenWidth(context) / 4,
            ),
            Text('Paid',
                style: appTheme!.black16Bold.copyWith(
                    color: ColorConstants.calenderGreyColor,
                    fontWeight: FontWeight.w600,
                    fontSize: getFontSize(10))),
          ],
        ),
      )
    ],
  );
}

// Appbar
AppBar getAppBarColor(BuildContext context, String title, String title2,
    {Widget? leadingButton,
    Brightness? brightness,
    List<Widget>? actionItems,
    bool isWhite = false,
    bool isTitleShow = true,
    TextAlign? textalign,
    PreferredSize? widget,
    bool? centerTitle}) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    leading: getBackButton(context),
    title: Padding(
      padding: EdgeInsets.only(left: getSize(55)),
      child: Row(
        children: [
          Text(
            title,
            style: appTheme?.black16Bold.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: getFontSize(18),
                color: Colors.white),
            textAlign: textalign ?? TextAlign.center,
          ),
          Text(
            title2,
            style: appTheme?.black16Bold.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: getFontSize(18),
                color: ColorConstants.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    backgroundColor:
        isWhite == true ? Colors.white : ColorConstants.mainBgColor,
    actions: actionItems == null ? null : actionItems,
    bottom: widget,
  );
}
