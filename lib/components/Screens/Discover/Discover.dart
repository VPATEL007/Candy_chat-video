import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchProfile.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/components/widgets/safeOnTap.dart';
import 'package:video_chat/provider/discover_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

class Discover extends StatefulWidget {
  static const route = "Discover";

  Discover({Key? key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<SortBy> tab = SortBy.values;
  int selectedIndex = 0;
  int page = 1;
  bool _switchValue = true;

  // List<MatchProfileModel> arrList = [];

  @override
  void initState() {
    super.initState();
    setUserStatus();
    // MatchProfileModel model = MatchProfileModel();
    // model.id = 123;
    // model.userName = "Mayur";
    // model.age = 14;
    // arrList.add(model);
  }

  setUserStatus() async {
    await Provider.of<DiscoverProvider>(context, listen: false)
        .getUserStatus(context);

    Provider.of<DiscoverProvider>(context, listen: false).userStatus == online
        ? setSwitchValue(true)
        : setSwitchValue(false);
    setState(() {});
  }

  setSwitchValue(value) {
    _switchValue = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Discover,
      ),
      body: Consumer<DiscoverProvider>(
        builder: (context, discover, child) => SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 15.0),
              child: Row(
                children: [
                  Text(
                    discover.userStatus == 'online'
                        ? 'You are now online'
                        : 'You are now offline',
                    style: discover.userStatus == 'online'
                        ? appTheme?.white14Bold.copyWith(color: Colors.green)
                        : appTheme?.white14Bold,
                  ),
                  Expanded(child: SizedBox()),
                  CupertinoSwitch(
                    trackColor: ColorConstants.grayBackGround,
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                        String status = discover.userStatus == 'online'
                            ? 'offline'
                            : 'online';
                        discover.setUserStatus(context, status);
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            getTabBar(discover),
            SizedBox(
              height: getSize(10),
            ),
            getUserList(discover.discoverProfileList, discover),
            // getUserList(arrList, discover),
            // getMatchButton()
          ],
        )),
      ),
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
            style: appTheme?.black16Bold.copyWith(color: ColorConstants.red),
          ),
        ),
      ),
    );
  }

  //List
  getUserList(
      List<MatchProfileModel> discoverList, DiscoverProvider discoverProvider) {
    return Expanded(
      child: GridView.builder(
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          shrinkWrap: true,
          itemCount: discoverList.length,
          padding: EdgeInsets.only(
              left: getSize(35), right: getSize(35), top: getSize(14)),
          itemBuilder: (BuildContext context, int index) {
            return LazyLoadingList(
              initialSizeOfItems: 20,
              index: index,
              hasMore: true,
              loadMore: () {
                print(
                    "--------========================= Lazy Loading ==========================---------");
                page++;
                discoverProvider.fetchDiscoverProfileList(
                    context, tab[selectedIndex],
                    pageNumber: page, isbackgroundCall: true);
              },
              child: InkWell(
                  onTap: () {
                    try {
                      MatchProfileModel matchProfileModel = discoverList[index];
                      if (matchProfileModel == null) return;
                      UserModel userModel = UserModel(
                          about: matchProfileModel.about,
                          dob: matchProfileModel.dob,
                          callRate: matchProfileModel.callRate,
                          gender: matchProfileModel.gender,
                          preferedGender: matchProfileModel.preferedGender,
                          photoUrl:
                              (matchProfileModel.imageUrl?.isEmpty ?? true)
                                  ? ""
                                  : matchProfileModel.imageUrl?.first ?? "",
                          userName: matchProfileModel.userName,
                          region: Region(
                              regionName: matchProfileModel.regionName,
                              regionFlagUrl: matchProfileModel.regionFlagUrl),
                          language: Language(
                              languageName: matchProfileModel.languageName),
                          userImages: matchProfileModel.imageUrl
                                  ?.map((e) => UserImage(photoUrl: e))
                                  .toList() ??
                              [],
                          byUserUserFollowers: matchProfileModel.followings,
                          userVisiteds: matchProfileModel.visitorCount ?? 0,
                          userFollowers: matchProfileModel.followers,
                          isFollowing: matchProfileModel.isFollowing == 1,
                          isFavourite: matchProfileModel.isFavourite == 1,
                          providerDisplayName:
                              matchProfileModel.providerDisplayName,
                          id: matchProfileModel.id,
                          totalPoint: matchProfileModel.totalPoint,
                          onlineStatus: matchProfileModel.onlineStatus,
                          countryIp: matchProfileModel.countryIp);
                      // if (userModel.photoUrl.isNotEmpty) {
                      //   userModel.userImages
                      //       .insert(0, UserImage(photoUrl: userModel.photoUrl));
                      // }
                      NavigationUtilities.push(UserProfile(
                        userModel: userModel,
                      ));
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: getUserItem(discoverList[index])),
            );
          }),
    );
  }

  Widget getUserItem(MatchProfileModel discover) {
    return Padding(
      padding: EdgeInsets.only(right: getSize(11), bottom: getSize(11)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            color: Colors.white,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: (discover.imageUrl?.isEmpty ?? true)
                      ? ""
                      : discover.imageUrl?.first ?? "",
                  width: (MathUtilities.screenWidth(context) / 2) - getSize(28),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    getUserPlaceHolder(discover.gender ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black38,
                ),
                (discover.regionFlagUrl?.isEmpty ?? true)
                    ? Container()
                    : Positioned(
                        left: 8,
                        top: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(getSize(12)),
                          child: CachedNetworkImage(
                            imageUrl: discover.regionFlagUrl ?? "",
                            height: getSize(20),
                            width: getSize(20),
                            fit: BoxFit.cover,
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
                          discover.age == null
                              ? Container()
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorConstants.button),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 6, right: 6, top: 4, bottom: 4),
                                    child: Text(
                                      discover.age.toString(),
                                      style: appTheme?.white14Bold.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: getSize(8)),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: getSize(8),
                          ),
                          Flexible(
                            child: Text(
                              discover.userName ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: appTheme?.white14Bold
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.5)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 4, right: 4, top: 2, bottom: 4),
                            child: Text(
                              "• ${discover.onlineStatus ?? ""}",
                              style: appTheme?.black16Bold.copyWith(
                                  fontSize: getSize(10),
                                  color: discover.onlineStatus == online
                                      ? fromHex("#00DE9B")
                                      : fromHex("#F55050")),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.5)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 4, right: 4, top: 2, bottom: 4),
                            child: Text(
                              "${discover.callRate ?? 0} Coins/minute",
                              style: appTheme?.black16Bold.copyWith(
                                  fontSize: getSize(10),
                                  color: ColorConstants.redText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, right: 8),
                    child: SafeOnTap(
                      intervalMs: 2000,
                      onSafeTap: () {
                        startCall(discover);
                      },
                      child: ClipRRect(
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
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  startCall(MatchProfileModel discover) async {
    await Provider.of<MatchingProfileProvider>(context, listen: false)
        .checkCoinBalance(context, discover.id ?? 0, discover.userName ?? "");

    CoinModel? coins =
        Provider.of<MatchingProfileProvider>(context, listen: false)
            .coinBalance;

    if (coins?.lowBalance == false) {
      // discover.id = 41;
      await Provider.of<MatchingProfileProvider>(context, listen: false)
          .startVideoCall(context, discover.id ?? 0);
      VideoCallModel? videoCallModel =
          Provider.of<MatchingProfileProvider>(context, listen: false)
              .videoCallModel;

      if (videoCallModel != null) {
        // videoCallModel.toUserId = 41;
        AgoraService.instance.sendVideoCallMessage(
            videoCallModel.toUserId.toString(),
            videoCallModel.sessionId ?? "",
            videoCallModel.channelName ?? "",
            discover.gender ?? "",
            context);
        Provider.of<VideoCallStatusProvider>(context, listen: false)
            .setCallStatus = CallStatus.Start;
        UserModel? userModel =
            Provider.of<FollowesProvider>(context, listen: false).userModel;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MatchedProfile(
            channelName: videoCallModel.channelName ?? "",
            token: videoCallModel.sessionId ?? "",
            fromId: videoCallModel.fromUserId.toString(),
            fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
                ? ""
                : userModel?.userImages?.first.photoUrl ?? "",
            name: discover.userName ?? "",
            toImageUrl: (discover.imageUrl?.isEmpty ?? true)
                ? ""
                : discover.imageUrl?.first ?? "",
            id: videoCallModel.toUserId.toString(),
            toGender: discover.gender ?? "",
          ),
        ));
      }
    } else if (coins?.lowBalance == true) {
      InAppPurchaseHelper.instance.openCoinPurchasePopUp();
    }
  }

//Tab
  Widget getTabBar(DiscoverProvider discoverProvider) {
    return Container(
      height: getSize(50),
      child: ListView.builder(
        padding: EdgeInsets.only(
            top: getSize(8), left: getSize(24), right: getSize(24)),
        scrollDirection: Axis.horizontal,
        itemCount: tab.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              if (mounted) {
                setState(() {
                  selectedIndex = index;
                });
              }
              discoverProvider.fetchDiscoverProfileList(context, tab[index],
                  isbackgroundCall: false);
            },
            child: Padding(
              padding: EdgeInsets.only(right: getSize(12)),
              child: Container(
                height: getSize(25),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: index == selectedIndex
                            ? ColorConstants.red
                            : Colors.white,
                        width: 1),
                    borderRadius: BorderRadius.circular(50),
                    color: index == selectedIndex
                        ? fromHex("#FFDFDF")
                        : Colors.black.withOpacity(0.03)),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: getSize(18),
                      right: getSize(18),
                      top: getSize(12),
                      bottom: getSize(12)),
                  child: Text(
                    describeEnum(tab[index]),
                    style: appTheme?.black12Normal.copyWith(
                        fontWeight: index == selectedIndex
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: index == selectedIndex
                            ? ColorConstants.redText
                            : Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
