import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/fade_route.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Chat/ChatList.dart';
import 'package:video_chat/components/Screens/Discover/Discover.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/components/Screens/Leaderboard/Leaderboard.dart';
import 'package:video_chat/components/Screens/Likes/LikesScreen.dart';
import 'package:video_chat/components/Screens/Profile/Profile.dart';
import 'package:video_chat/provider/followes_provider.dart';

class TabBarWidget extends StatefulWidget {
  TabType? screen = TabType.Home;

  TabBarWidget({Key? key, this.screen}) : super(key: key);

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstants.mainBgColor,
      child: Padding(
        padding: EdgeInsets.only(
            left: getSize(25),
            right: getSize(25),
            bottom: MathUtilities.safeAreaBottomHeight(context) > 20
                ? getSize(26)
                : getSize(16),
            top: getSize(21)),
        child: Container(
          height: getSize(74),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorConstants.grayBackGround,
                ColorConstants.grayBackGround
              ],
            ),
            borderRadius: BorderRadius.circular(
              getSize(18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  NavigationUtilities.pushReplacementNamed(Discover.route);
                },
                child: getTabItem(
                    widget.screen == TabType.Discover, "tablike", "Online Users"),
              ),
              InkWell(
                onTap: () {
                  NavigationUtilities.pushReplacementNamed(LikesScreen.route);
                },
                child: getTabItem(
                    widget.screen == TabType.Likes, "tabHome", "Likes"),
              ),
              InkWell(
                onTap: () {
                  NavigationUtilities.pushReplacementNamed(ChatList.route);
                },
                child: getTabItem(
                    widget.screen == TabType.Chat, "tabChat", "Messages"),
              ),
              InkWell(
                onTap: () {
                  NavigationUtilities.pushReplacementNamed(LeaderBoard.route);
                },
                child: getTabItem(
                    widget.screen == TabType.LeaderBoard, "ranking", "Ranking"),
              ),
              Consumer<FollowesProvider>(
                builder: (context, mutedProvider, child) =>
                    InkWell(
                        onTap: () async {
                          UserModel? userModel = mutedProvider.userModel;
                          if (userModel == null) {
                            await mutedProvider.fetchMyProfile(context);
                          }
                          setState(() {});
                          NavigationUtilities.key.currentState!
                              .pushReplacement(FadeRoute(
                            builder: (context) => Profile(),
                          ));
                        },
                        child: getTabProfileItem(
                            widget.screen == TabType.Profile,
                            (mutedProvider.userModel?.userImages?.isEmpty ??
                                true)
                                ? ""
                                : (mutedProvider
                                .userModel?.userImages?.first.photoUrl ??
                                ""),
                            mutedProvider.userModel?.gender ?? "")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTabProfileItem(bool isSelected, String image, String gender) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: (MathUtilities.screenWidth(context) - getSize(72)) / 5,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white.withOpacity(isSelected ? 1 : 0.6),
                      width: 1),
                  borderRadius: BorderRadius.circular(
                    18,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: (image.isEmpty)
                    ? Image.asset(
                  getUserPlaceHolder(gender),
                  height: 18,
                  width: 18,
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                  imageUrl: image,
                  height: 18,
                  width: 18,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        getUserPlaceHolder(gender),
                        height: 18,
                        width: 18,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: getSize(6),
        ),
        Text(
          "Profile",
          style: appTheme?.white12Normal.copyWith(
              fontWeight: FontWeight.w500,
              color:
              isSelected ? Colors.white : Colors.white.withOpacity(0.36)),
        )
      ],
    );
  }

  Widget getTabItem(bool isSelected, String icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: (MathUtilities.screenWidth(context) - getSize(72)) / 5,
          child: Center(
            child: Image.asset(
                "assets/Tab/$icon" + (isSelected ? "Selected.png" : ".png"),
                height: getSize(23),
                width: getSize(23),
                color: isSelected ? ColorConstants.red : Colors.white
                    .withOpacity(0.36)),
          ),
        ),
        SizedBox(
          height: getSize(6),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: appTheme?.white12Normal.copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? ColorConstants.red
                  : Colors.white.withOpacity(0.36)),
        )
      ],
    );
  }
}