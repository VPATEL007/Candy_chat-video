import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Screens/Home/MatchProfile.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';

class Discover extends StatefulWidget {
  static const route = "Discover";
  Discover({Key key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<String> tab = ["All Users", "Online", "Hot", "New Users", "Tranded"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Discover,
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getTabBar(),
          SizedBox(
            height: getSize(10),
          ),
          getUserList(),
          // getMatchButton()
        ],
      )),
    );
  }

  Widget getMatchButton() {
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

  //List
  getUserList() {
    return Expanded(
      child: GridView.builder(
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          shrinkWrap: true,
          itemCount: 10,
          padding: EdgeInsets.only(
              left: getSize(35), right: getSize(35), top: getSize(14)),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  NavigationUtilities.push(UserProfile());
                },
                child: getUserItem());
          }),
    );
  }

  Widget getUserItem() {
    return Padding(
      padding: EdgeInsets.only(right: getSize(11), bottom: getSize(11)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            color: Colors.red,
            height: 200,
            child: Stack(
              children: [
                Image.asset(
                  icTemp,
                  width: (MathUtilities.screenWidth(context) / 2) - getSize(28),
                  fit: BoxFit.cover,
                ),
                Positioned(
                    left: 8,
                    top: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(getSize(12)),
                      child: Image.asset(
                        l2,
                        height: getSize(20),
                        width: getSize(20),
                        fit: BoxFit.cover,
                      ),
                    )),
                Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black.withOpacity(0.5)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 4, right: 4, top: 2, bottom: 4),
                        child: Text(
                          "• Online",
                          style: appTheme.black16Bold.copyWith(
                              fontSize: getSize(10), color: fromHex("#00DE9B")),
                        ),
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    // left: 8,
                    // bottom: 8,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorConstants.button),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Text(
                                "21",
                                style: appTheme.white14Bold.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getSize(10)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getSize(8),
                          ),
                          Flexible(
                            child: Text(
                              "Ballaa",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: appTheme.white14Bold
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(getSize(35)),
                            child: Container(
                              color: fromHex("#00DE9B"),
                              child: Padding(
                                padding: EdgeInsets.all(getSize(12)),
                                child: Image.asset(
                                  icCall,
                                  color: Colors.white,
                                  height: getSize(16),
                                  width: getSize(16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }

//Tab
  Widget getTabBar() {
    return Container(
      height: getSize(50),
      child: ListView.builder(
        padding: EdgeInsets.only(
            top: getSize(8), left: getSize(24), right: getSize(24)),
        scrollDirection: Axis.horizontal,
        itemCount: tab.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(right: getSize(12)),
            child: Container(
              height: getSize(25),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: index == 0 ? ColorConstants.red : Colors.white,
                      width: 1),
                  borderRadius: BorderRadius.circular(50),
                  color: index == 0
                      ? fromHex("#FFDFDF")
                      : Colors.black.withOpacity(0.03)),
              child: Padding(
                padding: EdgeInsets.only(
                    left: getSize(18),
                    right: getSize(18),
                    top: getSize(12),
                    bottom: getSize(12)),
                child: Text(
                  tab[index],
                  style: appTheme.black12Normal.copyWith(
                      fontWeight:
                          index == 0 ? FontWeight.w700 : FontWeight.w600,
                      color:
                          index == 0 ? ColorConstants.redText : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
