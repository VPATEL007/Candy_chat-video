import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';
import 'package:video_chat/components/Screens/Profile/Coins.dart';
import 'package:video_chat/components/Screens/Profile/FollowUp.dart';
import 'package:video_chat/components/Screens/Profile/PaymentHistory.dart';
import 'package:video_chat/components/Screens/Profile/VipStore.dart';
import 'package:video_chat/components/Screens/Profile/Visitor.dart';
import 'package:video_chat/components/Screens/Setting/Setting.dart';
import 'package:video_chat/components/widgets/ProfileSlider.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';

class Profile extends StatefulWidget {
  static const route = "Profile";
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
                    getListItem(icVipStore, "VIP Store", true, () {
                      NavigationUtilities.push(VipStore());
                    }),
                    getListItem(icCoinP, "Get Coins", false, () {
                      NavigationUtilities.push(Coins());
                    }),
                    getListItem(icPaymentHistory, "Payment History ", false,
                        () {
                      NavigationUtilities.push(PaymentHistory());
                    }),
                    getListItem(icLanguage, "Language", false, () {
                      NavigationUtilities.push(LanguageSelection(
                        isChange: true,
                      ));
                    }),
                    getListItem(icSetting, "Settings", false, () {
                      NavigationUtilities.push(Setting());
                    })
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListItem(String icon, String title, bool isColor, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Padding(
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
                Image.asset(
                  icon,
                  height: getSize(26),
                  width: getSize(26),
                ),
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
      ),
    );
  }

  Widget getNavigation() {
    return Row(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            icLogout,
            height: getSize(26),
            width: getSize(26),
          )),
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
      Image.asset(
        icEdit,
        height: getSize(26),
        width: getSize(26),
      ),
    ]);
  }

  Widget getCounts() {
    return Row(
      children: [
        getCountItem("251", "Fans", () {}),
        Spacer(),
        getCountItem("2.6K", "Follow up", () {
          NavigationUtilities.push(FollowUp());
        }),
        Spacer(),
        getCountItem("36", "Visitor", () {
          NavigationUtilities.push(Visitor());
        })
      ],
    );
  }

  Widget getCountItem(String count, String title, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Container(
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
      ),
    );
  }

  Widget getProfile() {
    return Stack(
      children: [
        Container(
          height: getSize(300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(getSize(15)),
            child: ProfileSlider(
              scroll: (index) {
                currentIndex = index;
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
}
