import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';

import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/Screens/Home/Reportblock.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';

import 'Card/draggable_card.dart';
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

  RangeValues _currentRangeValues = const RangeValues(18, 24);
  SlideRegion region = SlideRegion.inSuperLikeRegion;
  int currentIndex = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ReportAndBlockProvider>(context, listen: false)
          .fetchReportReason(context);
    });
    _swipeItems = Provider.of<MatchingProfileProvider>(context, listen: false)
        .matchProfileList
        .map((e) => SwipeItem(
            content: Content(text: e.id.toString()),
            likeAction: (index) async {
              print("like $index");
              bool startCall = await Provider.of<MatchingProfileProvider>(
                      context,
                      listen: false)
                  .leftAndRightSwipe(context, SwipeType.Right);
              if (startCall == true) {
                VideoCallModel videoCallModel =
                    await Provider.of<MatchingProfileProvider>(context,
                            listen: false)
                        .startVideoCall(
                            context,
                            Provider.of<MatchingProfileProvider>(context,
                                    listen: false)
                                .matchProfileList[index]
                                .id);
                if (videoCallModel != null)
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoCall(
                      channelName: videoCallModel.channelName,
                      token: videoCallModel.sessionId,
                      userId: Provider.of<MatchingProfileProvider>(context,
                              listen: false)
                          .matchProfileList[index]
                          .id
                          ?.toString(),
                      toUserId: videoCallModel.toUserId.toString(),
                    ),
                  ));
              }
            },
            nopeAction: (index) {
              Provider.of<MatchingProfileProvider>(context, listen: false)
                  .leftAndRightSwipe(context, SwipeType.Left);
              print("nope");
            },
            superlikeAction: (index) {
              try {
                MatchProfileModel matchProfileModel =
                    Provider.of<MatchingProfileProvider>(context, listen: false)
                        .matchProfileList[index];
                if (matchProfileModel == null) return;
                UserModel userModel = UserModel(
                  about: matchProfileModel.about,
                  dob: matchProfileModel.dob,
                  callRate: matchProfileModel.callRate,
                  gender: matchProfileModel.gender,
                  preferedGender: matchProfileModel.preferedGender,
                  photoUrl: matchProfileModel.photoUrl,
                  userName: matchProfileModel.userName,
                  region: Region(
                      regionName: matchProfileModel.regionName,
                      regionFlagUrl: matchProfileModel.regionFlagUrl),
                  language:
                      Language(languageName: matchProfileModel.languageName),
                  userImages: matchProfileModel?.imageUrl
                          ?.map((e) => UserImage(photoUrl: e))
                          ?.toList() ??
                      [],
                  userVisiteds: [
                    UserVisited(
                        visitorsCount: matchProfileModel?.visitorCount ?? 0)
                  ],
                  byUserUserFollowers: [
                    ByUserUserFollower(
                        followersCount: matchProfileModel.followings)
                  ],
                  providerDisplayName: matchProfileModel.providerDisplayName,
                  id: matchProfileModel.id,
                  userFollowers: [
                    ByUserUserFollower(
                        followersCount: matchProfileModel.followers)
                  ],
                  totalPoint: matchProfileModel.totalPoint,
                  onlineStatus: matchProfileModel.onlineStatus,
                );

                if (userModel.photoUrl.isNotEmpty) {
                  userModel.userImages
                      .insert(0, UserImage(photoUrl: userModel.photoUrl));
                }

                openUserProfile(userModel);
                // NavigationUtilities.push(UserProfile());
              } catch (e) {
                print(e);
              }
            },
            onSlideUpdateAction: (tRegion, index) {
              setState(() {
                currentIndex = index;
                region = tRegion;
              });
            }))
        .toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MatchingProfileProvider>(
          builder: (ctx, matchProfileProvider, child) {
        return (matchProfileProvider.matchProfileList?.isEmpty ?? true)
            ? Container()
            : Container(
                child: Stack(
                  children: [
                    SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext ctx, int index) {
                        MatchProfileModel _matchProfile =
                            matchProfileProvider.matchProfileList[index];
                        return LazyLoadingList(
                          initialSizeOfItems: 20,
                          index: index,
                          hasMore: true,
                          loadMore: () {
                            print(
                                "--------========================= Lazy Loading ==========================---------");
                            page++;
                            Provider.of<MatchingProfileProvider>(context,
                                    listen: false)
                                .fetchMatchProfileList(context,
                                    isbackgroundCall: true, pageNumber: page);
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                height: MathUtilities.screenHeight(context),
                                width: MathUtilities.screenWidth(context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    getSize(MathUtilities.safeAreaTopHeight(
                                                context) >
                                            20
                                        ? getSize(16)
                                        : getSize(0)),
                                  ),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      _matchProfile?.photoUrl ?? "",
                                    ),
                                    onError: (exception, stackTrace) =>
                                        Image.asset(
                                      "assets/Profile/no_image.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: SafeArea(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: getSize(29),
                                            top: getSize(100)),
                                        child: Container(
                                          height: getSize(120),
                                          width: getSize(90),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                            borderRadius: BorderRadius.circular(
                                              getSize(7),
                                            ),
                                          ),
                                          child: Image.asset(icTemp),
                                        ),
                                      ),
                                      SizedBox(
                                        height: getSize(80),
                                      ),
                                      getLikeUnlike(index),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: getSize(90) +
                                          ((MathUtilities.safeAreaBottomHeight(
                                                      context) >
                                                  20)
                                              ? getSize(26)
                                              : getSize(16))),
                                  child: getDetailWidget(_matchProfile),
                                ),
                              ),
                              SafeArea(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: getSize(29),
                                          top: getSize(16),
                                          right: getFontSize(29)),
                                      child: getTopButton(icVector, () {
                                        NavigationUtilities.push(ReportBlock(
                                          userId: _matchProfile.id,
                                          reportImageURl:
                                              _matchProfile.photoUrl,
                                        ));
                                      })),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onStackFinished: () {
                        print("All Catch Up!");
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
                            child: getTopButton(icDrawer, () {
                              openFilter();
                            })),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TabBarWidget(
                        screen: TabType.Home,
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget getLikeUnlike(int index) {
    if (index == currentIndex) {
      if (region == SlideRegion.inLikeRegion) {
        return Padding(
          padding: EdgeInsets.only(left: getSize(40)),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: fromHex("#50F5C3"), width: 1),
              borderRadius: BorderRadius.circular(getSize(12)),
              color: fromHex("#50F5C3").withOpacity(0.5),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: getSize(46),
                  right: getSize(46),
                  top: getSize(15),
                  bottom: getSize(15)),
              child: Text(
                "Like",
                style: appTheme.whiteBold32,
              ),
            ),
          ),
        );
      } else if (region == SlideRegion.inNopeRegion) {
        return Padding(
          padding: EdgeInsets.only(
              right: getSize(20),
              left: MathUtilities.screenWidth(context) - 220),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(getSize(12)),
              color: Colors.red.withOpacity(0.5),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: getSize(46),
                  right: getSize(46),
                  top: getSize(15),
                  bottom: getSize(15)),
              child: Text(
                "Nope",
                style: appTheme.whiteBold32,
              ),
            ),
          ),
        );
      }
    }
    return SizedBox();
  }

  Widget getDetailWidget(MatchProfileModel matchedProfile) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getSize(70),
                      ),
                      Text(
                        matchedProfile?.regionName ?? "",
                        style: appTheme.black16Medium,
                      ),
                      SizedBox(
                        height: getSize(12),
                      ),
                      Text(
                        matchedProfile?.userName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appTheme.black16Bold
                            .copyWith(fontSize: getFontSize(25)),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                matchedProfile?.age == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: getSize(40)),
                        child: Text(
                          matchedProfile?.age?.toString(),
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
        child: Padding(
          padding: EdgeInsets.all(getSize(14)),
          child: Image.asset(
            image,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
      ),
    );
  }

  openUserProfile(UserModel userModel) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
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
                padding: EdgeInsets.only(top: getSize(35)),
                child: Container(
                  height: getSize(500),
                  child: UserProfile(
                    isPopUp: true,
                    userModel: userModel,
                  ),
                ),
              ));
            },
          );
        });
  }

//Open Filter
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
