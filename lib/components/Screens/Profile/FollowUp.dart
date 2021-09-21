import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Follwers/follow_model.dart';
import 'package:video_chat/provider/followes_provider.dart';

class FollowUp extends StatefulWidget {
  bool isFromFollowing;
  FollowUp({Key? key, this.isFromFollowing = false}) : super(key: key);

  @override
  _FollowUpState createState() => _FollowUpState();
}

class _FollowUpState extends State<FollowUp> {
  int page = 1;
  @override
  void initState() {
    super.initState();
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchFollowes(context);
    Provider.of<FollowesProvider>(context, listen: false)
        .fetchFollowing(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(
          context, widget.isFromFollowing ? "Following" : "Followers",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SafeArea(
        child: list(),
      ),
    );
  }

  Widget list() {
    return Consumer<FollowesProvider>(
        builder: (context, followesProvider, child) {
      List<FollowesModel> _followes = widget.isFromFollowing
          ? followesProvider.followingList
          : followesProvider.followersList;
      String noContentLabel = widget.isFromFollowing
          ? "No Following Found! "
          : "No Followers Found! ";
      return (_followes.isEmpty)
          ? Center(
              child: Text(
                noContentLabel,
                style: appTheme?.black14Normal.copyWith(
                    fontSize: getFontSize(16), fontWeight: FontWeight.w700),
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
                      if (widget.isFromFollowing) {
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
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 7,
                spreadRadius: 5,
                offset: Offset(0, 3)),
          ],
          color: Colors.white),
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
                      fontSize: getFontSize(16), fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: getSize(5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(getSize(12)),
                    //   child: Image.asset(
                    //     l2,
                    //     height: getSize(16),
                    //     width: getSize(16),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: getSize(6),
                    // ),
                    Text(
                      followes.byUser?.countryIp ?? "",
                      style: appTheme?.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            widget.isFromFollowing
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
}
