import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/date_utils.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/app/utils/navigator.dart';
import 'package:video_chat/components/Screens/Discover/Discover.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/provider/notification_provider.dart';

class RechargeNotificationScreen extends StatefulWidget {
  RechargeNotificationScreen({Key? key}) : super(key: key);

  @override
  State<RechargeNotificationScreen> createState() =>
      _RechargeNotificationScreenState();
}

class _RechargeNotificationScreenState
    extends State<RechargeNotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<RechargeNotificationProvider>(context, listen: false)
          .rechargeNotificationDetail(context, fetchInBackground: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationUtilities.pushReplacementNamed(Discover.route);
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.mainBgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getSize(30), vertical: getSize(22)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstants.bgColor,
                        size: getSize(18),
                      ),
                      Text(
                        'Notification',
                        style: TextStyle(
                            fontSize: getFontSize(18),
                            color: ColorConstants.red,
                            fontWeight: FontWeight.w700),
                      ),
                      Icon(Icons.notifications,
                          color: ColorConstants.red, size: getSize(24))
                    ],
                  ),
                ),
                Consumer<RechargeNotificationProvider>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.rechargeNotificationList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            NavigationUtilities.push(UserProfile(
                              isPopUp: true,
                              id: value.rechargeNotificationList[index].user
                                      ?.id ??
                                  0,
                            ));
                          },
                          child: cellItem(
                              imgUrl: value.rechargeNotificationList[index].user
                                      ?.userImages?.photoUrl ??
                                  '',
                              userName: value.rechargeNotificationList[index]
                                      .user?.userName ??
                                  '',
                              type:
                                  value.rechargeNotificationList[index].type ??
                                      '',
                              datetime: DateUtilities()
                                  .convertServerDateToFormatterString(
                                      value.rechargeNotificationList[index]
                                              .createdOn ??
                                          '',
                                      formatter: DateUtilities.h_mm_a)),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cellItem(
      {required String imgUrl,
      required String userName,
      required String type,
      required String datetime}) {
    return Container(
      height: getSize(60),
      margin:
          EdgeInsets.symmetric(horizontal: getSize(30), vertical: getSize(7)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [],
          color: ColorConstants.grayBackGround),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: getSize(10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    height: getSize(29),
                    width: getSize(29),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      icFollow,
                      height: getSize(48),
                      width: getSize(51),
                    ),
                  ),
                ),
                SizedBox(
                  width: getSize(11),
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: '$userName\t\t',
                          style: appTheme?.black14Normal.copyWith(
                              color: ColorConstants.black,
                              fontSize: getFontSize(12),
                              fontWeight: FontWeight.w700),
                          children: [
                        TextSpan(
                          text: type == 'recharge'
                              ? 'has made a recharge.'
                              : 'Likes You',
                          style: TextStyle(
                              fontSize: getFontSize(12),
                              color: ColorConstants.black,
                              fontWeight: FontWeight.w400),
                        )
                      ])),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: getSize(10)),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                datetime,
                style: appTheme?.black14Normal.copyWith(
                    color: ColorConstants.red,
                    fontSize: getFontSize(11),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
