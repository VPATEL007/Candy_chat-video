import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Payment/WithDrawRequestList.dart';
import 'package:video_chat/provider/withdraw_provider.dart';

class WithDrawHistory extends StatefulWidget {
  WithDrawHistory({Key key}) : super(key: key);

  @override
  _WithDrawHistoryState createState() => _WithDrawHistoryState();
}

class _WithDrawHistoryState extends State<WithDrawHistory> {
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WithDrawProvider>(context, listen: false)
          .getWithDrawRequest(page, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Withdraw History",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SafeArea(child: getList()),
    );
  }

  getList() {
    return Consumer<WithDrawProvider>(
      builder: (context, withDraw, child) =>
          (withDraw?.withDrawList?.isEmpty ?? true)
              ? Center(
                  child: Text("No Withdraw Request found!"),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                      top: getSize(20), left: getSize(25), right: getSize(25)),
                  itemCount: withDraw.withDrawList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LazyLoadingList(
                        initialSizeOfItems: 20,
                        index: index,
                        hasMore: true,
                        loadMore: () {
                          page++;
                          print(
                              "--------========================= Lazy Loading $page ==========================---------");

                          Provider.of<WithDrawProvider>(context, listen: false)
                              .getWithDrawRequest(page, context);
                        },
                        child: cellItem(withDraw.withDrawList[index]));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: getSize(15),
                    );
                  },
                ),
    );
  }

  Widget cellItem(WithDrawListModel model) {
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
                  (model?.coins?.toString() ?? "") + " Coins",
                  style:
                      appTheme.black16Bold.copyWith(fontSize: getFontSize(18)),
                ),
                SizedBox(
                  height: getSize(6),
                ),
                Text(
                  (model?.paymentMethod?.name ?? "") +
                      " - " +
                      (model?.paymentId ?? ""),
                  style: appTheme.black14SemiBold,
                ),
                SizedBox(
                  height: getSize(6),
                ),
                Row(
                  children: [
                    Text(
                      model?.requestStatus?.toUpperCase() ?? "",
                      style: appTheme.black14SemiBold,
                    ),
                    SizedBox(
                      width: getSize(6),
                    ),
                    Text(
                      DateFormat.yMMMd().format(model.createdOn),
                      style: appTheme.black12Normal,
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
            // Text(
            //   "100",
            //   style: appTheme.black14SemiBold,
            // ),
          ],
        ),
      ),
    );
  }
}
