import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';

import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/Reportblock.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/language_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';

import 'Card/draggable_card.dart';
import 'Card/swipe_cards.dart';

class MathProfile extends StatefulWidget {
  MathProfile({Key? key}) : super(key: key);

  @override
  _MathProfileState createState() => _MathProfileState();
}

class _MathProfileState extends State<MathProfile> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  late MatchEngine _matchEngine;
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  RangeValues _currentRangeValues = RangeValues(11, 50);
  int? selectedLanguage;
  String? selectedLanguageName;
  SlideRegion region = SlideRegion.inSuperLikeRegion;
  int currentIndex = 0;
  int page = 1;

  bool isLoadAll = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<LanguageProvider>(context, listen: false)
          .fetchLanguageList(context, true);
    });
    prepareSwipeItems();

    print(
        app.resolve<PrefUtils>().getInt(app.resolve<PrefUtils>().keyIsFromAge));
    _currentRangeValues = RangeValues(
        app
            .resolve<PrefUtils>()
            .getInt(app.resolve<PrefUtils>().keyIsFromAge)
            .toDouble(),
        app
            .resolve<PrefUtils>()
            .getInt(app.resolve<PrefUtils>().keyIsToAge)
            .toDouble());

    if (_currentRangeValues.start == 0 && _currentRangeValues.end == 0) {
      app
          .resolve<PrefUtils>()
          .saveInt(app.resolve<PrefUtils>().keyIsFromAge, 11);
      app.resolve<PrefUtils>().saveInt(app.resolve<PrefUtils>().keyIsToAge, 50);
      _currentRangeValues = RangeValues(11, 50);
    }
  }

  prepareSwipeItems() {
    if (page == 1) _swipeItems.clear();

    for (var e in Provider.of<MatchingProfileProvider>(context, listen: false)
        .matchProfileList) {
      var item = SwipeItem(
          content: e,
          likeAction: (index) async {
            print("like $index");
            var model =
                Provider.of<MatchingProfileProvider>(context, listen: false)
                    .matchProfileList[index];
            openProgressPopUp(model);
            // bool startCall = await Provider.of<MatchingProfileProvider>(context,
            //         listen: false)
            //     .leftAndRightSwipe(context, SwipeType.Right);
            // if (startCall == true) {
            //   await Provider.of<MatchingProfileProvider>(context, listen: false)
            //       .checkCoinBalance(
            //           context,
            // Provider.of<MatchingProfileProvider>(context,
            //         listen: false)
            //     .matchProfileList[index]
            //               .id,
            //           Provider.of<MatchingProfileProvider>(context,
            //                       listen: false)
            //                   .matchProfileList[index]
            //                   .userName ??
            //               "");

            //   CoinModel coins =
            //       Provider.of<MatchingProfileProvider>(context, listen: false)
            //           .coinBalance;

            //   if (coins?.lowBalance == false) {
            //     await Provider.of<MatchingProfileProvider>(context,
            //             listen: false)
            //         .startVideoCall(
            //             context,
            //             Provider.of<MatchingProfileProvider>(context,
            //                     listen: false)
            //                 .matchProfileList[index]
            //                 .id);
            //     VideoCallModel videoCallModel =
            //         Provider.of<MatchingProfileProvider>(context, listen: false)
            //             .videoCallModel;
            //     UserModel userModel =
            //         Provider.of<FollowesProvider>(context, listen: false)
            //             .userModel;
            //     if (videoCallModel != null)
            //       AgoraService.instance.sendVideoCallMessage(
            //           videoCallModel.toUserId.toString(),
            //           videoCallModel.sessionId,
            //           videoCallModel.channelName,
            //           Provider.of<MatchingProfileProvider>(context,
            //                       listen: false)
            //                   .matchProfileList[index]
            //                   .gender ??
            //               "",
            //           context);
            //     Provider.of<VideoCallStatusProvider>(context, listen: false)
            //         .setCallStatus = CallStatus.Start;
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => MatchedProfile(
            //         channelName: videoCallModel.channelName,
            //         token: videoCallModel.sessionId,
            //         fromId: Provider.of<MatchingProfileProvider>(context,
            //                 listen: false)
            //             .matchProfileList[index]
            //             .id
            //             ?.toString(),
            //         name: e?.providerDisplayName ?? "",
            //         toImageUrl: (e?.imageUrl?.isEmpty ?? true)
            //             ? ""
            //             : e?.imageUrl?.first ?? "",
            //         fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
            //             ? ""
            //             : userModel?.userImages?.first?.photoUrl ?? "",
            //         id: videoCallModel.toUserId.toString(),
            //         toGender: e?.gender ?? "",
            //       ),
            //     ));
            //   } else if (coins?.lowBalance == true) {
            //     InAppPurchase.instance.openCoinPurchasePopUp();
            //   }
            // }
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
                photoUrl: (matchProfileModel.imageUrl?.isEmpty ?? true)
                    ? ""
                    : matchProfileModel.imageUrl?.first ?? "",
                userName: matchProfileModel.userName,
                region: Region(
                    regionName: matchProfileModel.regionName,
                    regionFlagUrl: matchProfileModel.regionFlagUrl),
                language:
                    Language(languageName: matchProfileModel.languageName),
                userImages: matchProfileModel.imageUrl
                        ?.map((e) => UserImage(photoUrl: e))
                        .toList() ??
                    [],
                byUserUserFollowers: matchProfileModel.followings,
                userVisiteds: matchProfileModel.visitorCount ?? 0,
                userFollowers: matchProfileModel.followers,
                isFollowing: matchProfileModel.isFollowing == 1,
                isFavourite: matchProfileModel.isFavourite == 1,
                providerDisplayName: matchProfileModel.providerDisplayName,
                id: matchProfileModel.id,
                totalPoint: matchProfileModel.totalPoint,
                onlineStatus: matchProfileModel.onlineStatus,
              );

              openUserProfile(userModel);
            } catch (e) {
              print(e);
            }
          },
          onSlideUpdateAction: (tRegion, index) {
            setState(() {
              currentIndex = index;
              region = tRegion;
            });
          });
      _swipeItems.add(item);
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MatchingProfileProvider>(
          builder: (ctx, matchProfileProvider, child) {
        return Container(
          child: Stack(
            children: [
              (matchProfileProvider.matchProfileList.isEmpty) ||
                      (isLoadAll == true)
                  ? Center(
                      child: Text(
                        "You have viewed all the profiles. Go to home to restart match.",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext ctx, int index) {
                        MatchProfileModel _matchProfile =
                            matchProfileProvider.matchProfileList[index];
                        // MatchProfileModel _matchProfile =
                        //     _swipeItems[index].content;
                        return LazyLoadingList(
                          initialSizeOfItems: 20,
                          index: index,
                          hasMore: true,
                          loadMore: () async {
                            print(
                                "--------========================= Lazy Loading ==========================---------");
                            page++;
                            await Provider.of<MatchingProfileProvider>(context,
                                    listen: false)
                                .fetchMatchProfileList(context,
                                    isbackgroundCall: true,
                                    pageNumber: page,
                                    language: selectedLanguage,
                                    fromAge: _currentRangeValues.start.round(),
                                    toAge: _currentRangeValues.end.round(),
                                    isNotAppend: true);
                            prepareSwipeItems();
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
                                  image: _matchProfile.imageUrl?.isEmpty == true
                                      ? DecorationImage(
                                          image: AssetImage(getUserPlaceHolder(
                                              _matchProfile.gender ?? "")),
                                          fit: BoxFit.cover,
                                        )
                                      : DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            (_matchProfile.imageUrl?.isEmpty ??
                                                    true)
                                                ? ""
                                                : _matchProfile
                                                        .imageUrl?.first ??
                                                    "",
                                          ),
                                          onError: (exception, stackTrace) =>
                                              Image.asset(
                                            getUserPlaceHolder(
                                                _matchProfile.gender ?? ""),
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
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getSize(7),
                                              ),
                                            ),
                                            height: getSize(120),
                                            width: getSize(90),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getSize(7),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: (_matchProfile
                                                            .imageUrl
                                                            ?.isEmpty ??
                                                        true)
                                                    ? ""
                                                    : _matchProfile
                                                            .imageUrl?.first ??
                                                        "",
                                                width: getSize(90),
                                                height: getSize(120),
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  getUserPlaceHolder(
                                                      _matchProfile.gender ??
                                                          ""),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )

                                          // Container(
                                          //   height: getSize(120),
                                          //   width: getSize(90),
                                          //   decoration: BoxDecoration(
                                          //     border: Border.all(
                                          //         color: Colors.white, width: 1),
                                          //     borderRadius: BorderRadius.circular(
                                          //       getSize(7),
                                          //     ),
                                          //   ),
                                          //   child: Image.asset(icTemp),
                                          // ),
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
                                          gender: _matchProfile.gender ?? "",
                                          userId: _matchProfile.id,
                                          reportImageURl: (_matchProfile
                                                      .imageUrl?.isEmpty ??
                                                  true)
                                              ? ""
                                              : _matchProfile.imageUrl?.first ??
                                                  "",
                                        ));
                                      })),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onStackFinished: () {
                        if (mounted) {
                          setState(() {
                            isLoadAll = true;
                          });
                        }
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
                        // openProgressPopUp();
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
                style: appTheme?.whiteBold32,
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
                style: appTheme?.whiteBold32,
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
      onTap: () {},
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
                        matchedProfile.countryIp ?? "",
                        style: appTheme?.black16Medium,
                      ),
                      SizedBox(
                        height: getSize(20),
                      ),
                      (matchedProfile.userName?.isEmpty ?? true)
                          ? Container()
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                matchedProfile.userName ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: appTheme?.black16Bold
                                    .copyWith(fontSize: getFontSize(25)),
                              ),
                            ),
                    ],
                  ),
                ),
                Spacer(),
                matchedProfile.age == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: getSize(40)),
                        child: Text(
                          matchedProfile.age?.toString() ?? "",
                          style: appTheme?.black16Bold
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
          color: Colors.black.withOpacity(0.3),
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
  openFilter() async {
    var provider = Provider.of<LanguageProvider>(context, listen: false);

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
                            style: appTheme?.black16Bold
                                .copyWith(fontSize: getFontSize(25)),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Close",
                              style: appTheme?.black14SemiBold.copyWith(
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
                        style: appTheme?.black16Bold
                            .copyWith(fontSize: getFontSize(18)),
                      ),
                      SizedBox(
                        height: getSize(15),
                      ),
                      Container(
                        child: GridView.builder(
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, childAspectRatio: 2.5),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: provider.arrList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  selectedLanguage = provider.arrList[index].id;
                                  setState(() {});
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 6, bottom: 6),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: selectedLanguage ==
                                                    provider.arrList[index].id
                                                ? ColorConstants.red
                                                : Colors.white,
                                            width: 1),
                                        color: selectedLanguage ==
                                                provider.arrList[index].id
                                            ? fromHex("#FFDFDF")
                                            : fromHex("#F1F1F1"),
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Center(
                                      child: Text(
                                        provider.arrList[index].languageName ??
                                            "",
                                        style: appTheme!.black12Normal.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: selectedLanguage ==
                                                    provider.arrList[index].id
                                                ? ColorConstants.red
                                                : Colors.black),
                                      ),
                                    )),
                              );
                              // return getCoinItem(index == 0, context);
                            }),
                      ),
                      SizedBox(
                        height: getSize(35),
                      ),
                      Row(
                        children: [
                          Text(
                            "Age",
                            style: appTheme?.black16Bold
                                .copyWith(fontSize: getFontSize(18)),
                          ),
                          Spacer(),
                          Text(
                            _currentRangeValues.start.round().toString() +
                                ' - ' +
                                _currentRangeValues.end.round().toString(),
                            style: appTheme?.black14Normal
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
                      getPopBottomButton(context, "Apply", () async {
                        app.resolve<PrefUtils>().saveInt(
                            app.resolve<PrefUtils>().keyIsFromAge,
                            _currentRangeValues.start.toInt());
                        app.resolve<PrefUtils>().saveInt(
                            app.resolve<PrefUtils>().keyIsToAge,
                            _currentRangeValues.end.toInt());
                        Navigator.pop(context);
                        page = 1;
                        await Provider.of<MatchingProfileProvider>(context,
                                listen: false)
                            .fetchMatchProfileList(context,
                                isbackgroundCall: true,
                                pageNumber: page,
                                language: selectedLanguage,
                                fromAge: _currentRangeValues.start.round(),
                                toAge: _currentRangeValues.end.round(),
                                isNotAppend: true);
                        prepareSwipeItems();
                      })
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  openProgressPopUp(MatchProfileModel model) {
    AgoraService.instance.sendLikeMessage(model.id.toString(), context);
    showDialog(
        context: context,
        builder: (builder) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Center(
                child: Container(
                  width: MathUtilities.screenWidth(context) - 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0, 4),
                            blurRadius: 4),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(getSize(24)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            CircularCountDownTimer(
                              duration: 30,
                              initialDuration: 0,
                              controller: CountDownController(),
                              width: getSize(120),
                              height: getSize(120),
                              ringColor: Colors.white,
                              ringGradient: null,
                              fillColor: ColorConstants.redText,
                              fillGradient: null,
                              backgroundColor: Colors.white,
                              backgroundGradient: null,
                              strokeWidth: 6,
                              strokeCap: StrokeCap.round,
                              textStyle: TextStyle(
                                  fontSize: 0.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textFormat: CountdownTextFormat.S,
                              isReverse: false,
                              isReverseAnimation: false,
                              isTimerTextShown: false,
                              autoStart: true,
                              onStart: () {
                                print('Countdown Started');
                              },
                              onComplete: () {
                                Navigator.pop(context);
                              },
                            ),
                            Positioned(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(119),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          (model.imageUrl?.isEmpty ?? true)
                                              ? ""
                                              : model.imageUrl?.first ?? "",
                                      width: getSize(119),
                                      height: getSize(119),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        getUserPlaceHolder(model.gender ?? ""),
                                        width: getSize(119),
                                        height: getSize(119),
                                        fit: BoxFit.cover,
                                      ),
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          model.userName ?? "",
                          style: appTheme?.black14SemiBold
                              .copyWith(fontSize: getFontSize(16)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "You like " +
                              (model.userName ?? "") +
                              ". Waiting for reply.",
                          textAlign: TextAlign.center,
                          style: appTheme?.black16Bold
                              .copyWith(fontSize: getFontSize(18)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class Content {
  final String? text;

  Content({this.text});
}
