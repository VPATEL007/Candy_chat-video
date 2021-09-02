import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/apple_login_helper.dart';
import 'package:video_chat/app/Helper/facebook_login_helper.dart';
import 'package:video_chat/app/Helper/google_signin_helper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Auth/Login.dart';
import 'package:video_chat/components/Screens/Language%20Selection/Language.dart';
import 'package:video_chat/components/Screens/Profile/Coins.dart';
import 'package:video_chat/components/Screens/Profile/FollowUp.dart';
import 'package:video_chat/components/Screens/Profile/PaymentHistory.dart';
import 'package:video_chat/components/Screens/Profile/VipStore.dart';
import 'package:video_chat/components/Screens/Profile/Visitor.dart';
import 'package:video_chat/components/Screens/Profile/edit_profile.dart';
import 'package:video_chat/components/Screens/Setting/Setting.dart';
import 'package:video_chat/components/Screens/Splash/Splash.dart';
import 'package:video_chat/components/widgets/ProfileSlider.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/feedback_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';

class Profile extends StatefulWidget {
  Profile({
    Key key,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchFollowes(context);
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchFollowing(context);
    Provider.of<FeedBackProvider>(context, listen: false)
        .fetchFeedBacks(context);
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchMyProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Profile,
      ),
      backgroundColor: Colors.white,
      body: Consumer<FollowesProvider>(
        builder: (context, profie, child) => SafeArea(
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
                      getProfile(profie.userModel),
                      SizedBox(
                        height: getSize(16),
                      ),
                      getCounts(profie.userModel),
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
                      }),
                      getListItem(icLogout, "Logout", false, () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Center(child: Text("Logout")),
                            content: Text(
                              "Are you sure you want to Logout?",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  GoogleSignInHelper.instance.handleSignOut();
                                  FacebookLoginHelper.shared.logout();
                                  app
                                      .resolve<PrefUtils>()
                                      .clearPreferenceAndDB();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => Splash(),
                                      ),
                                      (route) => false);
                                },
                                child: Text("Logout"),
                              )
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                )),
              ],
            ),
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
                title == "Logout"
                    ? Container()
                    : Image.asset(
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
      // InkWell(
      //   onTap: () {
      //     GoogleSignInHelper.instance.handleSignOut();
      //     FacebookLoginHelper.shared.logout();

      //     app.resolve<PrefUtils>().clearPreferenceAndDB();
      //     Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(
      //           builder: (context) => Splash(),
      //         ),
      //         (route) => false);
      //   },
      //   child: Align(
      //       alignment: Alignment.topLeft,
      //       child: Image.asset(
      //         icLogout,
      //         height: getSize(26),
      //         width: getSize(26),
      //       )),
      // ),
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
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProfileScreen(),
          ));
        },
        child: Image.asset(
          icEdit,
          height: getSize(26),
          width: getSize(26),
        ),
      ),
    ]);
  }

  Widget getCounts(UserModel userModel) {
    return Row(
      children: [
        Expanded(
          child: getCountItem(
              (userModel?.userFollowers ?? 0)?.toString(), "Followers", () {
            NavigationUtilities.push(FollowUp());
          }),
        ),
        SizedBox(width: 15),
        Expanded(
          child: getCountItem(
              (userModel?.byUserUserFollowers ?? 0)?.toString(), "Following",
              () {
            NavigationUtilities.push(FollowUp(
              isFromFollowing: true,
            ));
          }),
        ),
        SizedBox(width: 15),
        Expanded(
            child: getCountItem(
                (userModel?.userVisiteds ?? 0).toString(), "Visitor", () {
          NavigationUtilities.push(Visitor());
        })),
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appTheme.black16Bold.copyWith(
                    fontSize: getFontSize(16), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfile(UserModel userModel) {
    return Stack(
      children: [
        Container(
          height: getSize(300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(getSize(15)),
            child: ProfileSlider(
              images:
                  userModel?.userImages?.map((e) => e.photoUrl)?.toList() ?? [],
              gender: userModel?.gender ?? "",
              scroll: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(getSize(15)),
        //   child: Container(
        //     height: getSize(300),
        //     color: Colors.black38,
        //   ),
        // ),
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
                  getColorText(userModel?.userName ?? "", Colors.white),
                  SizedBox(
                    height: getSize(8),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      userModel?.region?.regionFlagUrl?.isEmpty ?? true
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(getSize(12)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    userModel?.region?.regionFlagUrl ?? "",
                                height: getSize(16),
                                width: getSize(16),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Image.asset("assets/Profile/no_image.png"),
                              ),
                            ),
                      userModel?.region?.regionFlagUrl?.isEmpty ?? true
                          ? Container()
                          : SizedBox(
                              width: getSize(6),
                            ),
                      Text(
                        userModel?.countryIp ?? "",
                        style: appTheme.white14Normal
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Text(
                        "ID : ${userModel?.id}",
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
                children: List.generate(
                    userModel?.userImages?.length ?? 0,
                    (index) => pageIndexIndicator(
                        currentIndex == index ? true : false))))
      ],
    );
  }
}
