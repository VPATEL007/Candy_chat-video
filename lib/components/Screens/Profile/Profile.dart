import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';

class Profile extends StatefulWidget {
  static const route = "Profile";
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Profile,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: getSize(35), right: getSize(35)),
          child: Column(
            children: [
              SizedBox(
                height: getSize(16),
              ),
              getNavigation(),
              SizedBox(
                height: getSize(19),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    getProfile(),
                    SizedBox(
                      height: getSize(16),
                    ),
                    getCounts(),
                    SizedBox(
                      height: getSize(16),
                    ),
                    getNavigationItem(icVipStore, "VIP Store", true),
                    getNavigationItem(icCoinP, "Get Coins", false),
                    getNavigationItem(
                        icPaymentHistory, "Payment History ", false),
                    getNavigationItem(icLanguage, "Language", false),
                    getNavigationItem(icSetting, "Settings", false)
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getNavigationItem(String icon, String title, bool isColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: getSize(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            getSize(16),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isColor
                ? [ColorConstants.gradiantStart, ColorConstants.red]
                : [fromHex("#F7F7F7"), fromHex("#F7F7F7")],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: getSize(16),
              top: getSize(16),
              right: getSize(16),
              bottom: getSize(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(icon),
              SizedBox(
                width: getSize(23),
              ),
              Text(
                title,
                style: appTheme.white16Normal.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isColor ? Colors.white : Colors.black),
              ),
              Spacer(),
              Image.asset(
                icDetail,
                color: isColor ? Colors.white : Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getNavigation() {
    return Row(children: [
      Align(alignment: Alignment.topLeft, child: Image.asset(icLogout)),
      Spacer(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getColorText("My", Colors.black),
          SizedBox(
            width: getSize(6),
          ),
          getColorText("Profile", ColorConstants.red),
        ],
      ),
      Spacer(),
      Image.asset(icEdit),
    ]);
  }

  Widget getCounts() {
    return Row(
      children: [
        getCountItem("251", "Fans"),
        Spacer(),
        getCountItem("2.6K", "Follow up"),
        Spacer(),
        getCountItem("36", "Visitor")
      ],
    );
  }

  Widget getCountItem(String count, String title) {
    return Container(
      decoration: BoxDecoration(
          color: fromHex("#F7F7F7"), borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: EdgeInsets.only(
            left: getSize(22),
            right: getSize(22),
            top: getSize(15),
            bottom: getSize(15)),
        child: Column(
          children: [
            Text(
              count,
              style: appTheme.black16Bold.copyWith(
                  fontSize: getFontSize(16),
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.redText),
            ),
            SizedBox(
              height: getSize(4),
            ),
            Text(
              title,
              style: appTheme.black16Bold.copyWith(
                  fontSize: getFontSize(16), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfile() {
    return Stack(
      children: [
        Container(
          height: getSize(300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: PageView(
              controller: pageController,
              children: [
                getPageViewItem(icTempProfile),
                getPageViewItem(loginBg),
                getPageViewItem(icTempProfile)
              ],
              onPageChanged: (val) {
                currentIndex = val;
                pageController.animateToPage(currentIndex,
                    duration: Duration(milliseconds: 600),
                    curve: Curves.linearToEaseOut);
                setState(() {});
              },
            ),
          ),
        ),
        Positioned(
          bottom: getSize(16),
          child: Container(
            width: getSize(324),
            child: Padding(
              padding: EdgeInsets.only(left: getSize(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getColorText("Luiz Fernando", Colors.white),
                  SizedBox(
                    height: getSize(8),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(getSize(12)),
                        child: Image.asset(
                          l2,
                          height: getSize(16),
                          width: getSize(16),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: getSize(6),
                      ),
                      Text(
                        "Australia",
                        style: appTheme.white14Normal
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Text(
                        "ID : 13245686",
                        style: appTheme.white14Normal
                            .copyWith(fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
            left: getSize(10),
            bottom: getSize(140),
            child: Column(
              children: [
                pageIndexIndicator(currentIndex == 2 ? true : false),
                pageIndexIndicator(currentIndex == 1 ? true : false),
                pageIndexIndicator(currentIndex == 0 ? true : false),
              ],
            ))
      ],
    );
  }

  getPageViewItem(String image) {
    return Image.asset(
      image,
      width: MathUtilities.screenWidth(context),
      height: getSize(300),
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.4),
      colorBlendMode: BlendMode.overlay,
    );
  }

  Widget pageIndexIndicator(bool isCuurent) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(vertical: 3),
      height: getSize(10),
      width: getSize(10),
      decoration: BoxDecoration(
          border: Border.all(
              width: isCuurent ? 0 : 2,
              color: Colors.white,
              style: BorderStyle.solid),
          color: isCuurent ? ColorConstants.red : Colors.white.withOpacity(0),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
