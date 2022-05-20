import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/Match%20Profile/search_profile.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';

import '../../../provider/followes_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController();
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<FollowesProvider>(context, listen: false)
    //     .fetchSearchUser(context, pageNumber: page);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          searchTextField(),
          Expanded(
            child: Container(
                height: MathUtilities.screenWidth(context),
                alignment: Alignment.center,
                child: searchUserList()),
          )
        ],
      ),
    );
  }

  Widget searchTextField() => Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
        height: 60,
        child: TextFormField(
          style: TextStyle(
              fontSize: getFontSize(16),
              color: ColorConstants.textGray,
              fontWeight: FontWeight.normal),
          onChanged: (value) {
            if (value.length >= 3) {
              page = 1;
              Provider.of<FollowesProvider>(context, listen: false)
                  .fetchSearchUser(context, pageNumber: 1, keyword: value);
            } else if (value == '') {
              page = 1;
              Provider.of<FollowesProvider>(context, listen: false)
                  .searchList
                  .clear();
            }
          },
          controller: search,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(90.0),
                borderSide: BorderSide(
                  color: ColorConstants.redText,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(90.0),
                borderSide: BorderSide(
                  color: ColorConstants.redText,
                  width: 1.0,
                ),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: ColorConstants.redText,
              ),
              contentPadding: EdgeInsets.only(top: 10.0, left: 15.0),
              hintStyle: TextStyle(
                  fontSize: getFontSize(16),
                  color: ColorConstants.textGray,
                  fontWeight: FontWeight.normal),
              filled: false,
              hintText: 'Search...'),
        ),
      );

  Widget searchUserList() {
    return Consumer<FollowesProvider>(
        builder: (context, followesProvider, child) {
      List<SearchProfileData> searchList = followesProvider.searchList;
      String noContentLabel = 'Enter the name or id of the user to search';
      return (searchList.isEmpty)
          ? Center(
              child: InkWell(
                onTap: () {
                  Provider.of<FollowesProvider>(context, listen: false)
                      .fetchSearchUser(context, pageNumber: page);
                },
                child: Text(
                  noContentLabel,
                  style: appTheme?.black14Normal.copyWith(
                      fontSize: getFontSize(16),
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.only(
                  top: getSize(16),
                  left: getSize(25),
                  right: getSize(25),
                  bottom: getSize(28)),
              itemCount: searchList.length,
              itemBuilder: (BuildContext context, int index) {
                return LazyLoadingList(
                    initialSizeOfItems: 20,
                    index: index,
                    hasMore: true,
                    loadMore: () {
                      page++;
                      print(
                          "--------========================= Lazy Loading $page ==========================---------");
                      Provider.of<FollowesProvider>(context, listen: false)
                          .fetchSearchUser(context, pageNumber: page);
                    },
                    child: cellItem(searchList[index], followesProvider));
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: getSize(15),
                );
              },
            );
    });
  }

  Widget cellItem(
      SearchProfileData searchProfileModel, FollowesProvider followesProvider) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => UserProfile(
                      id: searchProfileModel.id,
                    )));
      },
      child: Container(
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
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: (searchProfileModel.imageUrl?.isEmpty ?? true)
                          ? ""
                          : searchProfileModel.imageUrl?.first ?? "",
                      height: getSize(48),
                      width: getSize(51),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        getUserPlaceHolder('gender'),
                        height: getSize(48),
                        width: getSize(51),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1.0,
                    bottom: 1.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 8.0,
                      child: CircleAvatar(
                        foregroundColor: ColorConstants.activeStatusColor,
                        radius: 5.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: getSize(11),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.0,
                    child: Text(
                      searchProfileModel.userName ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: appTheme?.black14Normal.copyWith(
                          color: Colors.white,
                          fontSize: getFontSize(16),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: getSize(5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        searchProfileModel.userLevel ?? "",
                        style: appTheme?.black14Normal.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: SizedBox(
                height: 10.0,
              )),
              searchProfileModel.callProbability == true
                  ? Column(
                      children: [
                        Image.asset(
                          icCallProbability,
                          height: getSize(25),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Call Probability',
                          style: TextStyle(
                              fontSize: getFontSize(8),
                              color: ColorConstants.textGray,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    )
                  : Container(),
              Expanded(
                child: SizedBox(
                  height: 10.0,
                ),
              ),
              searchProfileModel.liked == true
                  ? followIcon()
                  : notFollowingIcon(),
              // isILike[0]
              //     ? TextButton(
              //   onPressed: () {
              //     followesProvider.unfollowUser(
              //         context, followes.byUser?.id ?? 0);
              //   },
              //   child: Text(
              //     "Remove",
              //     style: appTheme?.black12Normal.copyWith(
              //         color: ColorConstants.redText,
              //         fontWeight: FontWeight.w700),
              //   ),
              // )
              //     : Container()
            ],
          ),
        ),
      ),
    );
  }
}
