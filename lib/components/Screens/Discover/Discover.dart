import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/match_profile.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchProfile.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/components/Screens/VideoCall/VideoCall.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/discover_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';

class Discover extends StatefulWidget {
  static const route = "Discover";
  Discover({Key key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<SortBy> tab = SortBy.values;
  int selectedIndex = 0;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Discover,
      ),
      body: Consumer<DiscoverProvider>(
        builder: (context, discover, child) => SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getTabBar(discover),
            SizedBox(
              height: getSize(10),
            ),
            getUserList(discover.discoverProfileList, discover),
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
            style: appTheme.black16Bold.copyWith(color: ColorConstants.red),
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
                discoverProvider.fetchDiscoverProfileList(context, tab[index],
                    pageNumber: page, isbackgroundCall: false);
              },
              child: InkWell(
                  onTap: () {
                    MatchProfileModel matchProfileModel = discoverList[index];
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
                      language: Language(
                          languageName: matchProfileModel.languageName),
                      userImages: matchProfileModel?.imageUrl
                              ?.map((e) => UserImage(photoUrl: e))
                              ?.toList() ??
                          [],
                      byUserUserFollowers: [],
                      providerDisplayName:
                          matchProfileModel.providerDisplayName,
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
                    NavigationUtilities.push(UserProfile(
                      userModel: userModel,
                    ));
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
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: discover?.photoUrl ?? "",
                  width: (MathUtilities.screenWidth(context) / 2) - getSize(28),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/Profile/no_image.png",
                    fit: BoxFit.cover,
                  ),
                ),
                (discover?.regionFlagUrl?.isEmpty ?? true)
                    ? Container()
                    : Positioned(
                        left: 8,
                        top: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(getSize(12)),
                          child: CachedNetworkImage(
                            imageUrl: discover?.regionFlagUrl ?? "",
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
                          "• ${discover?.onlineStatus ?? ""}",
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
                         discover?.age == null
                                  ? Container()
                                  :  Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorConstants.button),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: Text(
                                      discover?.age.toString() ?? "",
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
                              discover?.userName,
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
                            child: InkWell(
                              onTap: () async {
                                VideoCallModel videoCallModel =
                                    await Provider.of<MatchingProfileProvider>(
                                            context,
                                            listen: false)
                                        .startVideoCall(context, discover.id);
                                if (videoCallModel != null)
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VideoCall(
                                      channelName: videoCallModel.channelName,
                                      token: videoCallModel.sessionId,
                                      userId:
                                          videoCallModel.fromUserId.toString(),
                                      toUserId:
                                          videoCallModel.toUserId.toString(),
                                    ),
                                  ));
                              },
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
                    style: appTheme.black12Normal.copyWith(
                        fontWeight: index == selectedIndex
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: index == selectedIndex
                            ? ColorConstants.redText
                            : Colors.black),
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
