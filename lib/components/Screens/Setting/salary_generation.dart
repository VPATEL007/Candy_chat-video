import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Screens/Setting/income_report.dart';
import 'package:video_chat/provider/income_report_provider.dart';

class SalaryGeneration extends StatefulWidget {
  final String firstDate;
  final String endDate;

  const SalaryGeneration(
      {Key? key, required this.firstDate, required this.endDate})
      : super(key: key);

  @override
  State<SalaryGeneration> createState() => _SalaryGenerationState();
}

class _SalaryGenerationState extends State<SalaryGeneration> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyEarningDetailProvider>(context, listen: false)
          .weeklyDetailEarningReport(context,
              startDate: widget.firstDate, endDate: widget.endDate);
    });
    resetPagination();
    super.initState();
  }

  int page = 0;

  resetPagination() {
    page = 1;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<DailyEarningDetailProvider>(context, listen: false)
          .weeklyDetailEarningReport(context,
              startDate: widget.firstDate, endDate: widget.endDate, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      appBar: getAppBarColor(context, 'Salary\t', 'Details'),
      body: Consumer<DailyEarningDetailProvider>(
        builder: (context, value, child) => Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(20)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: value.weeklyDetailEarningList.length,
              itemBuilder: (context, index) {
                return LazyLoadingList(
                  initialSizeOfItems: 5,
                  index: index,
                  hasMore: true,
                  loadMore: () {
                    page++;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<DailyEarningDetailProvider>(context,
                              listen: false)
                          .weeklyDetailEarningReport(context,
                              startDate: widget.firstDate,
                              endDate: widget.endDate,
                              page: page);
                    });
                  },
                  child: getTitle(
                      weeklyDate:
                          '${value.weeklyDetailEarningList[index].startWeekDate.toIso8601String().substring(0, 10)}  to  ${value.weeklyDetailEarningList[index].endWeekDate.toIso8601String().substring(0, 10)}',
                      status: value.weeklyDetailEarningList[index].status,
                      paymentMode:
                          value.weeklyDetailEarningList[index].paymentMode,
                      currency: value.weeklyDetailEarningList[index].currency,
                      totalCoins:
                          value.weeklyDetailEarningList[index].totalCoins,
                      callCoins: value.weeklyDetailEarningList[index].callCoins,
                      giftCoins: value.weeklyDetailEarningList[index].giftCoins,
                      referralCoins:
                          value.weeklyDetailEarningList[index].referralCoins,
                      albumCoins:
                          value.weeklyDetailEarningList[index].albumCoins,
                      context: context),
                );
              },
            )),
      ),
    );
  }

  Widget getTitle(
      {required String weeklyDate,
      required String status,
      required String paymentMode,
      required String currency,
      required int totalCoins,
      required int callCoins,
      required int giftCoins,
      required int referralCoins,
      required int albumCoins,
      required BuildContext context}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: getSize(7)),
      width: MathUtilities.screenWidth(context),
      decoration: BoxDecoration(
          color: ColorConstants.grayBackGround,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              color: ColorConstants.red,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(15), vertical: getSize(10)),
                child: Row(
                  children: [
                    Text('Week Number :',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.bgColor,
                            fontSize: getFontSize(14))),
                    const Spacer(),
                    Text(weeklyDate,
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.bgColor,
                            fontSize: getFontSize(14))),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(17)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: getSize(5)),
                  child: Row(
                    children: [
                      Text('Total Coins',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.red,
                              fontSize: getFontSize(14))),
                      const Spacer(),
                      Text('$totalCoins',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.bgColor,
                              fontSize: getFontSize(14))),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('Call Coins',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.red,
                            fontSize: getFontSize(14))),
                    const Spacer(),
                    Text('$callCoins',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.bgColor,
                            fontSize: getFontSize(14))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: getSize(5)),
                  child: Row(
                    children: [
                      Text('Gift Coins',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.red,
                              fontSize: getFontSize(14))),
                      const Spacer(),
                      Text('$giftCoins',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.bgColor,
                              fontSize: getFontSize(14))),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('Referral Coins',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.red,
                            fontSize: getFontSize(14))),
                    const Spacer(),
                    Text('$referralCoins',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.bgColor,
                            fontSize: getFontSize(14))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: getSize(5)),
                  child: Row(
                    children: [
                      Text('Album Coins',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.red,
                              fontSize: getFontSize(14))),
                      const Spacer(),
                      Text('$albumCoins',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.bgColor,
                              fontSize: getFontSize(14))),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('Status',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.red,
                            fontSize: getFontSize(14))),
                    const Spacer(),
                    Text(status,
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.bgColor,
                            fontSize: getFontSize(14))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: getSize(5)),
                  child: Row(
                    children: [
                      Text('Payment Mode :',
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.red,
                              fontSize: getFontSize(14))),
                      const Spacer(),
                      Text(paymentMode,
                          style: appTheme?.black16Bold.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorConstants.bgColor,
                              fontSize: getFontSize(14))),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text('Currency',
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.red,
                            fontSize: getFontSize(14))),
                    const Spacer(),
                    Text(currency,
                        style: appTheme?.black16Bold.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.bgColor,
                            fontSize: getFontSize(14))),
                  ],
                ),
                SizedBox(height: getSize(10))
              ],
            ),
          )
        ],
      ),
    );
  }
}
