import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/Setting/EarnHistory.dart';
import 'package:video_chat/components/widgets/CommanButton.dart';
import 'package:video_chat/provider/income_report_provider.dart';

class IncomeReport extends StatefulWidget {
  const IncomeReport({Key? key}) : super(key: key);

  @override
  State<IncomeReport> createState() => _IncomeReportState();
}

class _IncomeReportState extends State<IncomeReport> {
  bool isWeeklySelected = false;
  int? selectedIndex;


  late int todayIndex;
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;

    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  List<List> finalList = [];
  List sundayIndex = [];
  int sunday = 0;

  List<DateTime> vijaylist = [];

  getDate() {
    List<DateTime> finalList =
        daysInRange(DateTime(2022, 07, 05), DateTime(2023));

    for (int i = 0; i < finalList.length; i++) {
      final DateFormat formatter = DateFormat('E');
      final formatteds = formatter.format(finalList[i]);
      if (formatteds == 'Mon') {
        vijaylist.add(DateTime(2022, 07, 01));
        vijaylist.add(finalList[i]);
      } else {
        vijaylist.add(finalList[i]);
      }
    }
  }

  sunDayWeeklyList() {
    List dataList = List.generate(
        daysInRange.call(DateTime(2022, 07, 05), DateTime(2023)).length,
        (index) =>
            daysInRange.call(DateTime(2022, 07, 05), DateTime(2023))[index]);

    for (int i = 0; i < dataList.length; i++) {
      final DateFormat formatter = DateFormat('E');
      final formatteds = formatter.format(dataList[i]);

      if (formatteds == 'Mon') {
        sundayIndex.add(daysInRange
            .call(DateTime(2022, 07, 05), DateTime(2023))[i]
            .toIso8601String()
            .substring(8, 10));
        finalList.add(sundayIndex.toSet().toList());

        sundayIndex.clear();
      } else {
        sundayIndex.add(daysInRange
            .call(DateTime(2022, 07, 05), DateTime(2023))[i]
            .toIso8601String()
            .substring(8, 10));
      }
    }
  }

  ScrollController? scrollController =  ScrollController();

  @override
  void initState() {
    getDate();
    sunDayWeeklyList();

    for (int i = 0; i < vijaylist.length; i++) {
      DateTime datetime = DateTime.now();

      if (vijaylist[i].toIso8601String().substring(0, 10) ==
          datetime.toIso8601String().substring(0, 10)) {
        int todayindex = vijaylist.indexWhere((element) =>
            element.toIso8601String().substring(0, 10) ==
            datetime.toIso8601String().substring(0, 10));
        setState(() {
          todayIndex = todayindex;
          selectedIndex = todayIndex;
        });
      } else {
        print('no');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {

      double _position =  todayIndex.toDouble() * (getSize(36));
      print(_position);
      setState(() {
        scrollController?.animateTo(
            _position,
            duration: Duration(milliseconds: 1000),
            curve: Curves.ease
        );
      });
    });

    Provider.of<DailyEarningDetailProvider>(context, listen: false)
        .dailyEarningReport(context,
            dateTime: DateTime.now().toIso8601String().substring(0, 10));
    super.initState();
  }

  String? formatted;
  String? monthFormatted;

  String selectedDate = DateTime.now().toIso8601String();

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
                      itemCount: vijaylist.length,
                      itemBuilder: (context, index) {
                        final DateFormat formatter = DateFormat('E');
                        formatted = formatter.format(vijaylist[index]);
                        final DateFormat formatter2 = DateFormat('yMMMM');
                        monthFormatted = formatter2.format(vijaylist[index]);

                        return vijaylist[index] == DateTime(2022, 07, 01)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (vijaylist[index] ==
                                        DateTime(2022, 07, 01)) {
                                      sunday++;
                                    }
                                    isWeeklySelected = true;
                                    Provider.of<DailyEarningDetailProvider>(
                                            context,
                                            listen: false)
                                        .weeklyEarningReport(context,
                                            dateTime: '2022-07-15');
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: isWeeklySelected
                                              ? getSize(10)
                                              : 0),
                                      width:
                                          isWeeklySelected ? getSize(72) : null,
                                      height: isWeeklySelected
                                          ? getSize(33)
                                          : getSize(30),
                                      decoration: BoxDecoration(
                                          color: isWeeklySelected
                                              ? ColorConstants.red
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isWeeklySelected
                                                ? getSize(5)
                                                : getSize(10),
                                            vertical: isWeeklySelected
                                                ? getSize(3)
                                                : 0),
                                        child: Text(
                                          'Weekly',
                                          style: appTheme!.black16Bold.copyWith(
                                              color: isWeeklySelected
                                                  ? ColorConstants.mainBgColor
                                                  : ColorConstants
                                                      .calenderGreyColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getFontSize(11)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: isWeeklySelected
                                          ? getSize(1)
                                          : getSize(18),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: isWeeklySelected
                                              ? getSize(10)
                                              : 0),
                                      alignment: isWeeklySelected
                                          ? Alignment.bottomCenter
                                          : null,
                                      width:
                                          isWeeklySelected ? getSize(72) : null,
                                      height: isWeeklySelected
                                          ? getSize(33)
                                          : getSize(30),
                                      decoration: BoxDecoration(
                                          color: isWeeklySelected
                                              ? ColorConstants.red
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isWeeklySelected
                                                ? getSize(5)
                                                : getSize(10),
                                            vertical: isWeeklySelected
                                                ? getSize(3)
                                                : 0),
                                        child: Text(
                                          '${daysInRange.call(DateTime(2022, 07, 05), DateTime(2023))[index].month}/${finalList[sunday].first}-${daysInRange.call(DateTime(2022, 07, 05), DateTime(2023))[index].month}/${finalList[sunday].last}',
                                          style: appTheme!.black16Bold.copyWith(
                                              color: isWeeklySelected
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

                                    selectedIndex = index;
                                    selectedDate =
                                        vijaylist[index].toIso8601String();
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
                                          formatted!,
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
                                          '${vijaylist[index].day}',
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
                        getTitle(
                            totalCoin:
                                value.weeklyEariningReportModel?.totalCoins ??
                                    0),
                        getBox(
                            context: context,
                            title: 'Video call coins',
                            coin: value.weeklyEariningReportModel
                                    ?.videoCallCoins ??
                                0,
                            onTap: () {
                              print('object');
                              NavigationUtilities.push(EarnHistory(
                                  selectedDate: selectedDate.substring(0, 10)));
                            }),
                        getBox(
                            context: context,
                            title: 'Gifts coins',
                            coin:
                                value.weeklyEariningReportModel?.giftsCoin ?? 0,
                            onTap: () {
                              print('object2');
                            }),
                        getBox(
                            context: context,
                            title: 'Match total',
                            coin: value.weeklyEariningReportModel?.matchCoin ??
                                0),
                        getBox(
                            context: context,
                            title: 'Referral Coins',
                            coin:
                                value.weeklyEariningReportModel?.refralCoins ??
                                    0),
                        getBox(
                            context: context,
                            title: 'Albums coins',
                            coin: value.weeklyEariningReportModel?.albumCoin ??
                                0),
                        getBox(
                            context: context,
                            title: 'Weekly video call duration',
                            coin: 0,
                            isDuration: true,
                            duration: value.weeklyEariningReportModel
                                    ?.weeklyCallDuration ??
                                ''),
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
                            coin:
                                value.dailyEarningReportModel?.videoCallCoins ??
                                    0,
                            onTap: () {
                              print('object');
                              NavigationUtilities.push(EarnHistory(
                                  selectedDate: selectedDate.substring(0, 10)));
                            }),
                        getBox(
                            context: context,
                            title: 'Gifts coins',
                            coin: value.dailyEarningReportModel?.giftsCoin ?? 0,
                            onTap: () {
                              print('object2');
                            }),
                        getBox(
                            context: context,
                            title: 'Match total',
                            coin:
                                value.dailyEarningReportModel?.matchCoin ?? 0),
                        getBox(
                            context: context,
                            title: 'Referral Coins',
                            coin: value.dailyEarningReportModel?.refralCoins ??
                                0),
                        getBox(
                            context: context,
                            title: 'Albums coins',
                            coin:
                                value.dailyEarningReportModel?.albumCoin ?? 0),
                        getBox(
                            context: context,
                            title: 'Weekly video call duration',
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
              CommanButton(),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(12)),
            child: Image.asset(
              questionIcon,
              height: getSize(19),
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
getStepProgressIndicator(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            minRadius: getSize(13),
            maxRadius: getSize(13),
            backgroundColor: ColorConstants.red,
            child: CircleAvatar(
              minRadius: getSize(7),
              maxRadius: getSize(7),
              backgroundColor: ColorConstants.colorPrimary,
            ),
          ),
          Container(
            height: 1,
            width: MathUtilities.screenWidth(context) / 4,
            color: ColorConstants.colorPrimary,
          ),
          CircleAvatar(
            minRadius: getSize(13),
            maxRadius: getSize(13),
            backgroundColor: ColorConstants.calenderGreyColor,
          ),
          Container(
            height: 1,
            width: MathUtilities.screenWidth(context) / 4,
            color: ColorConstants.colorPrimary,
          ),
          CircleAvatar(
            minRadius: getSize(13),
            maxRadius: getSize(13),
            backgroundColor: ColorConstants.calenderGreyColor,
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(45), vertical: getSize(10)),
        child: Row(
          children: [
            Text('Calculating',
                style: appTheme!.black16Bold.copyWith(
                    color: ColorConstants.red,
                    fontWeight: FontWeight.w600,
                    fontSize: getFontSize(10))),
            SizedBox(
              width: MathUtilities.screenWidth(context) / 5,
            ),
            Text('Paying',
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
