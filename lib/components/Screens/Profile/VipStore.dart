import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class VipStore extends StatefulWidget {
  VipStore({Key key}) : super(key: key);

  @override
  _VipStoreState createState() => _VipStoreState();
}

class _VipStoreState extends State<VipStore> {
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MathUtilities.screenHeight(context),
          child: PageView(
            controller: pageController,
            onPageChanged: (val) {
              currentIndex = val;
              pageController.animateToPage(currentIndex,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.linearToEaseOut);
              setState(() {});
            },
            children: [
              getPageViewItem(vip1, "#50F5C3"),
              getPageViewItem(vip2, "#9950F5"),
              getPageViewItem(vip3, "#F55050"),
              getPageViewItem(vip4, "#50CDF5"),
              getPageViewItem(vip5, "#50F57E"),
            ],
          ),
        ),
        Positioned(child: getNaviagtion()),
        Align(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageIndexIndicator(currentIndex == 0 ? true : false),
                pageIndexIndicator(currentIndex == 1 ? true : false),
                pageIndexIndicator(currentIndex == 2 ? true : false),
                pageIndexIndicator(currentIndex == 3 ? true : false),
                pageIndexIndicator(currentIndex == 4 ? true : false),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  getNaviagtion() {
    return SafeArea(
      child: Container(
        child: Row(
          children: [
            getBackButton(context),
            Spacer(),
            getColorText("VIP Store", Colors.black, fontSize: getFontSize(16)),
            Spacer(),
            SizedBox(
              width: getSize(18),
            )
          ],
        ),
      ),
    );
  }

  getPageViewItem(String image, String color) {
    return Container(
      child: Column(
        children: [
          Container(
              width: MathUtilities.screenWidth(context),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [fromHex(color), Colors.white],
              )),
              child: Padding(
                padding: EdgeInsets.only(top: getSize(61)),
                child: SafeArea(child: Image.asset(image)),
              )),
          Text(
            "Become Dating App VIP",
            style: appTheme.black16Bold,
          ),
          SizedBox(
            height: getSize(16),
          ),
          Text(
            "Unlimited chat",
            style: appTheme.black16Bold.copyWith(fontSize: getFontSize(20)),
          ),
          SizedBox(
            height: getSize(13),
          ),
          Text(
            "Chat with anyone you want to know",
            style: appTheme.black14Normal.copyWith(fontSize: getFontSize(16)),
          ),
          Spacer(),
          Container(
            width: MathUtilities.screenWidth(context) - getSize(70),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  getSize(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ColorConstants.gradiantStart, ColorConstants.red],
                )),
            child: Column(
              children: [
                SizedBox(
                  height: getSize(12),
                ),
                Text(
                  "Contiune",
                  style: appTheme.white16Normal
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: getSize(4),
                ),
                Text(
                  "\$130.00/Month",
                  style: appTheme.white16Normal
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: getSize(12),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "Recurring billing. cancel anytime",
            style: appTheme.black14Normal.copyWith(fontSize: getFontSize(16)),
          ),
          SizedBox(
            height: getSize(13),
          ),
          Padding(
            padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing and ",
              textAlign: TextAlign.center,
              style: appTheme.black14Normal.copyWith(fontSize: getFontSize(16)),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget pageIndexIndicator(bool isCuurent) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(horizontal: 3),
      height: getSize(10),
      width: getSize(10),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isCuurent ? ColorConstants.red : Colors.grey,
              style: BorderStyle.solid),
          color: isCuurent ? ColorConstants.red : Colors.white.withOpacity(0),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
