import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/date_utils.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/app/utils/price_utility.dart';
import 'package:video_chat/components/Model/payment_history_model.dart';
import 'package:video_chat/provider/payment_history.dart';

class PaymentHistory extends StatefulWidget {
  PaymentHistory({Key? key}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  int page = 1;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    resetPagination();
  }

  resetPagination() {
    page = 1;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<PaymentHistoryProvider>(context, listen: false)
          .fetchPaymentHistory(
              context,
              DateUtilities().getFormattedDateString(_selectedDate,
                  formatter: DateUtilities.yyyy_mm_dd));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Payment History",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SafeArea(
          child: Column(
        children: [
          InkWell(
            onTap: () {
              _selectDate();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: ColorConstants.borderColor.withAlpha(60),
                    borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 10, bottom: 10),
                  child: Text(
                    DateFormat.yMMMd().format(_selectedDate),
                    style: appTheme?.black16Medium
                        .copyWith(fontSize: getFontSize(20)),
                  ),
                )),
          ),
          Expanded(
            child: getList(),
          )
        ],
      )),
    );
  }

  getList() {
    return Consumer<PaymentHistoryProvider>(
      builder: (context, payemntHistory, child) =>
          (payemntHistory.paymentHistory.isEmpty)
              ? Center(
                  child: Text("No Payment History found!"),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                      top: getSize(20), left: getSize(25), right: getSize(25)),
                  itemCount: payemntHistory.paymentHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LazyLoadingList(
                        initialSizeOfItems: 20,
                        index: index,
                        hasMore: true,
                        loadMore: () {
                          page++;
                          print(
                              "--------========================= Lazy Loading $page ==========================---------");

                          Provider.of<PaymentHistoryProvider>(context,
                                  listen: false)
                              .fetchPaymentHistory(
                                  context,
                                  DateUtilities().getFormattedDateString(
                                      _selectedDate,
                                      formatter: DateUtilities.yyyy_mm_dd),
                                  pageNumber: page,
                                  fetchInBackground: true);
                        },
                        child: cellItem(payemntHistory.paymentHistory[index]));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: getSize(15),
                    );
                  },
                ),
    );
  }

  Widget cellItem(PaymentHistoryModel paymentHistory) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 7,
                spreadRadius: 5,
                offset: Offset(0, 3)),
          ],
          color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(
            top: getSize(20),
            bottom: getSize(20),
            left: getSize(20),
            right: getSize(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icDiamond,
              height: getSize(35),
              width: getSize(35),
            ),
            SizedBox(
              width: getSize(14),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentHistory.data?.packageName ?? "",
                  style:
                      appTheme?.black16Bold.copyWith(fontSize: getFontSize(18)),
                ),
                SizedBox(
                  height: getSize(3),
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(paymentHistory.purchasedOn ?? DateTime.now()),
                  style: appTheme?.black12Normal,
                ),
              ],
            ),
            Spacer(),
            Text(
              "${simpleCurrencySymbols[paymentHistory.currency]}${paymentHistory.paidAmount}",
              style: appTheme?.black14SemiBold,
            )
          ],
        ),
      ),
    );
  }

  _selectDate() async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext? context, Widget? child) {
          return child ?? Container();
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      setState(() {});
      resetPagination();
    }
  }
}
