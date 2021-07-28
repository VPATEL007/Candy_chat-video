import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';

import 'Card/swipe_cards.dart';

class MathProfile extends StatefulWidget {
  MathProfile({Key key}) : super(key: key);

  @override
  _MathProfileState createState() => _MathProfileState();
}

class _MathProfileState extends State<MathProfile> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  RangeValues _currentRangeValues = const RangeValues(18, 24);

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i]),
          likeAction: () {
            print("like");
          },
          nopeAction: () {
            print("nope");
          },
          superlikeAction: () {
            print("supper");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: MathUtilities.screenHeight(context),
                  width: MathUtilities.screenWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      getSize(MathUtilities.safeAreaTopHeight(context) > 20
                          ? getSize(16)
                          : getSize(0)),
                    ),
                    image: DecorationImage(
                      image: AssetImage(icTemp),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: getSize(29), top: getSize(100)),
                          child: Container(
                            height: getSize(120),
                            width: getSize(90),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(
                                getSize(7),
                              ),
                            ),
                            child: Image.asset(icTemp),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              onStackFinished: () {
                print("asdad");
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: getSize(29),
                        top: getSize(16),
                        right: getFontSize(29)),
                    child: Row(
                      children: [
                        getTopButton(icDrawer, () {
                          openFilter();
                        }),
                        Spacer(),
                        getTopButton(icVector, () {}),
                      ],
                    )),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [getDetailWidget(), TabBarWidget()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDetailWidget() {
    return InkWell(
      onTap: () {
        NavigationUtilities.push(MatchedProfile());
      },
      child: Container(
        height: getSize(150),
        width: MathUtilities.screenWidth(context) - getSize(72),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            getSize(18),
          ),
          image: DecorationImage(
            image: AssetImage(icHomeCurve),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getSize(70),
                    ),
                    Text(
                      "Australia",
                      style: appTheme.black16Medium,
                    ),
                    SizedBox(
                      height: getSize(12),
                    ),
                    Text(
                      "Mihani Miller",
                      style: appTheme.black16Bold
                          .copyWith(fontSize: getFontSize(25)),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: getSize(40)),
                  child: Text(
                    "26",
                    style: appTheme.black16Bold
                        .copyWith(fontSize: getFontSize(35)),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  getTopButton(String image, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            getSize(50),
          ),
          color: Colors.white.withOpacity(0.3),
        ),
        height: getSize(50),
        width: getSize(50),
        child: Image.asset(image),
      ),
    );
  }

  openFilter() {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: getSize(23), left: getSize(26), right: getSize(26)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Filter",
                            style: appTheme.black16Bold
                                .copyWith(fontSize: getFontSize(25)),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Close",
                              style: appTheme.black14SemiBold.copyWith(
                                  fontSize: getFontSize(18),
                                  color: ColorConstants.red),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: getSize(18),
                      ),
                      Text(
                        "Language",
                        style: appTheme.black16Bold
                            .copyWith(fontSize: getFontSize(18)),
                      ),
                      SizedBox(
                        height: getSize(15),
                      ),
                      Container(
                        child: Tags(
                            itemCount: 8,
                            spacing: getSize(8),
                            runSpacing: getSize(20),
                            alignment: WrapAlignment.center,
                            itemBuilder: (int index) {
                              return ItemTags(
                                active: index == 0 ? true : false,
                                pressEnabled: true,
                                activeColor: fromHex("#FFDFDF"),
                                title: "English",
                                index: index,
                                textStyle: appTheme.black12Normal
                                    .copyWith(fontWeight: FontWeight.w500),
                                textColor: Colors.black,
                                textActiveColor: ColorConstants.red,
                                color: fromHex("#F1F1F1"),
                                elevation: 0,
                                padding: EdgeInsets.only(
                                    left: getSize(16),
                                    right: getSize(16),
                                    top: getSize(7),
                                    bottom: getSize(7)),
                              );
                            }),
                      ),
                      SizedBox(
                        height: getSize(35),
                      ),
                      Row(
                        children: [
                          Text(
                            "Age",
                            style: appTheme.black16Bold
                                .copyWith(fontSize: getFontSize(18)),
                          ),
                          Spacer(),
                          Text(
                            "18 - 25",
                            style: appTheme.black14Normal
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: _currentRangeValues,
                        min: 11,
                        max: 50,
                        divisions: 40,
                        inactiveColor: fromHex("#EDEDED"),
                        activeColor: ColorConstants.red,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                      SizedBox(
                        height: getSize(33),
                      ),
                      getPopBottomButton(context, "Apply", () {})
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

class Content {
  final String text;

  Content({this.text});
}
