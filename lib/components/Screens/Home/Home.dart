import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/CommonApiHelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Screens/Home/MatchProfile.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/discover_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/tags_provider.dart';

class Home extends StatefulWidget {
  static const route = "Home";
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String get getRandomNumberString {
    Random rnd = new Random();
    int number = rnd.nextInt(9999);

    return number.toString();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchMyProfile(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DiscoverProvider>(context, listen: false)
          .fetchDiscoverProfileList(context, SortBy.General);
      Provider.of<TagsProvider>(context, listen: false).fetchTags(context);
      CommonApiHelper.shared.getRTMToken(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Home,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getSize(28),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getColorText("Matching", ColorConstants.red),
                SizedBox(
                  width: getSize(6),
                ),
                getColorText("Profile", ColorConstants.black)
              ],
            ),
            SizedBox(
              height: getSize(50),
            ),
            Container(
              height: getSize(280),
              width: getSize(280),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icCircleHome),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Container(
                  height: getSize(110),
                  width: getSize(110),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstants.red, width: 4),
                    borderRadius: BorderRadius.circular(
                      getSize(110),
                    ),
                    image: DecorationImage(
                      image: AssetImage(loginBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      getRandomNumberString,
                      style: appTheme.white14Bold
                          .copyWith(fontSize: getFontSize(25)),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getColorText("Find", ColorConstants.black),
                SizedBox(
                  width: getSize(6),
                ),
                getColorText("your", ColorConstants.black),
                SizedBox(
                  width: getSize(6),
                ),
                getColorText("Partner", ColorConstants.red),
              ],
            ),
            SizedBox(
              height: getSize(4),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getColorText("with", ColorConstants.black),
                SizedBox(
                  width: getSize(6),
                ),
                getColorText("Us", ColorConstants.black),
              ],
            ),
            SizedBox(
              height: getSize(12),
            ),
            Padding(
              padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
              child: Text(
                "Girls in real time interaction\n Find your Dream girl right now!",
                textAlign: TextAlign.center,
                style: appTheme.black14Normal,
              ),
            ),
            Spacer(),
            getMatchButton(),
          ],
        ),
      ),
    );
  }

  getMatchButton() {
    return InkWell(
      onTap: () async {
        await Provider.of<MatchingProfileProvider>(context, listen: false)
            .fetchMatchProfileList(context);
        NavigationUtilities.push(MathProfile());
      },
      child: Container(
        height: getSize(50),
        width: MathUtilities.screenWidth(context) - getSize(70),
        decoration: BoxDecoration(
          color: fromHex("#FFDFDF"),
          border: Border.all(color: ColorConstants.red, width: 1),
          borderRadius: BorderRadius.circular(
            getSize(16),
          ),
        ),
        child: Center(
          child: Text(
            "Start Matching",
            style: appTheme.black16Bold.copyWith(color: ColorConstants.red),
          ),
        ),
      ),
    );
  }
}
