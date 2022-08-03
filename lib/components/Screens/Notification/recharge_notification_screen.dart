import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class RechargeNotificationScreen extends StatelessWidget {
  const RechargeNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: getSize(30),vertical: getSize(22)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios,color: ColorConstants.bgColor,size: getSize(18),),
                    Text(
                     'Notification',
                      style: TextStyle(
                          fontSize: getFontSize(18),
                          color: ColorConstants.red,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.notifications,color: ColorConstants.red,size: getSize(24))
                  ],
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 8,
                itemBuilder: (context, index) {
                return cellItem();
              },)
            ],
          ),
        ),
      ),
    );
  }

  Widget cellItem() {
    return Container(
      height: getSize(60),
      margin: EdgeInsets.symmetric(horizontal: getSize(30),vertical: getSize(7)),
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
            padding:  EdgeInsets.symmetric(horizontal: getSize(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: CachedNetworkImage(
                    imageUrl: 'https://images.pexels.com/photos/589840/pexels-photo-589840.jpeg?cs=srgb&dl=pexels-valiphotos-589840.jpg&fm=jpg',
                    height: getSize(29),
                    width: getSize(29),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(icApple,
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
                    text: 'Xiaoming Tian\t\t',
                      style: appTheme?.black14Normal.copyWith(
                          color: ColorConstants.black,
                          fontSize: getFontSize(12),
                          fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(
                        text: 'has made a recharge.',
                        style: TextStyle(
                            fontSize: getFontSize(12),
                            color: ColorConstants.black,
                            fontWeight: FontWeight.w400),
                      )
                    ]
                  )),
                )
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(right: getSize(10)),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "10:21 PM",
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
