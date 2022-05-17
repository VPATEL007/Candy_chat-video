import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/EnumConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Follwers/follow_model.dart';
import 'package:video_chat/components/Screens/Likes/search_screen.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/followes_provider.dart';

class LikesScreen extends StatefulWidget {
  static const route = "LikesScreen";

  LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  PageController pageController = new PageController(initialPage: 0);
  List<bool> isILike = [true, false, false];
  int page = 1;
  int currentIndex = 0;
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchFollowes(context);
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchFollowing(context);
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchSearchUser(context);
  }

  resetSelectedState() {
    isILike = [false, false, false];
  }

  setIndexZero() {
    isSearch = false;
    resetSelectedState();
    isILike[0] = true;
    currentIndex = 0;
  }

  setIndexOne() {
    isSearch = false;
    resetSelectedState();
    isILike[1] = true;
    currentIndex = 1;
  }

  setIndexTwo() {
    isSearch = true;
    resetSelectedState();
    isILike[2] = true;
    currentIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Likes,
      ),
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    setIndexZero();
                    pageController.animateToPage(currentIndex,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.linearToEaseOut);
                  },
                  child: getTabItem('I Like', 0)),
              InkWell(
                  onTap: () {
                    setIndexOne();
                    pageController.animateToPage(currentIndex,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.linearToEaseOut);
                  },
                  child: getTabItem('Like me', 1)),
              InkWell(
                  onTap: () {
                    setIndexTwo();
                    pageController.animateToPage(currentIndex,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.linearToEaseOut);
                  },
                  child: getTabItem('Search', 2)),
            ],
          ),
          Container(
            height: MathUtilities.screenHeight(context) / 1.3,
            child: PageView(
              controller: pageController,
              onPageChanged: (val) {
                if (val == 0) {
                  setIndexZero();
                } else if (val == 1) {
                  setIndexOne();
                } else {
                  setIndexTwo();
                }
                currentIndex = val;
                setState(() {});
              },
              children: [list(), list(), SearchScreen()],
            ),
          )
        ]),
      ),
    );
  }

  Widget list() {
    return Consumer<FollowesProvider>(
        builder: (context, followesProvider, child) {
      List<FollowesModel> _followes = isILike[0] == true
          ? followesProvider.followingList
          : followesProvider.followersList;
      String noContentLabel = isILike[0] == true
          ? 'No data found'
          : isILike[1] == true
              ? 'No like me data found'
              : 'No search data found';
      return (_followes.isEmpty)
          ? Center(
              child: Text(
                noContentLabel,
                style: appTheme?.black14Normal.copyWith(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.only(
                  top: getSize(16),
                  left: getSize(25),
                  right: getSize(25),
                  bottom: getSize(28)),
              itemCount: _followes.length,
              itemBuilder: (BuildContext context, int index) {
                return LazyLoadingList(
                    initialSizeOfItems: 20,
                    index: index,
                    hasMore: true,
                    loadMore: () {
                      page++;
                      print(
                          "--------========================= Lazy Loading $page ==========================---------");
                      if (isILike[0] == true) {
                        Provider.of<FollowesProvider>(context, listen: false)
                            .fetchFollowing(context, pageNumber: page);
                      } else {
                        Provider.of<FollowesProvider>(context, listen: false)
                            .fetchFollowes(context, pageNumber: page);
                      }
                    },
                    child: cellItem(_followes[index], followesProvider));
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: getSize(15),
                );
              },
            );
    });
  }

  Widget cellItem(FollowesModel followes, FollowesProvider followesProvider) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [],
          color: ColorConstants.grayBackGround),
      child: Padding(
        padding: EdgeInsets.only(
            top: getSize(8),
            bottom: getSize(8),
            left: getSize(10),
            right: getSize(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: (followes.byUser?.userImages?.isEmpty ?? true)
                    ? ""
                    : followes.byUser?.userImages?.first.photoUrl ?? "",
                height: getSize(48),
                width: getSize(51),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                  getUserPlaceHolder(followes.byUser?.gender ?? ""),
                  height: getSize(48),
                  width: getSize(51),
                ),
              ),
            ),
            SizedBox(
              width: getSize(11),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  followes.byUser?.providerDisplayName ?? "",
                  style: appTheme?.black14Normal.copyWith(
                      color: Colors.white,
                      fontSize: getFontSize(16),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: getSize(5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      followes.byUser?.countryIp ?? "",
                      style: appTheme?.black14Normal.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            isILike[0]
                ? TextButton(
                    onPressed: () {
                      followesProvider.unfollowUser(
                          context, followes.byUser?.id ?? 0);
                    },
                    child: Text(
                      "Remove",
                      style: appTheme?.black12Normal.copyWith(
                          color: ColorConstants.redText,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  //Get Tab Item
  Widget getTabItem(String title, index) {
    print('index==> $index');
    return Container(
      width: MathUtilities.screenWidth(context) / 3,
      child: Column(
        children: [
          Text(
            title,
            style: appTheme?.black14SemiBold.copyWith(
                fontSize: getFontSize(16),
                color: isILike[index] == true
                    ? ColorConstants.redText
                    : Colors.white),
          ),
          SizedBox(
            height: getSize(12),
          ),
          Container(
              height: 1,
              color: isILike[index] == true
                  ? ColorConstants.redText
                  : Colors.white,
              width: MathUtilities.screenWidth(context) / 2)
        ],
      ),
    );
  }
}
