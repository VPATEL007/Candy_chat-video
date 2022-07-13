import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_tags/simple_tags.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Gift/ReceivedGiftModel.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/Screens/Home/Reportblock.dart';
import 'package:video_chat/components/widgets/ProfileSlider.dart';
import 'package:video_chat/components/widgets/safeOnTap.dart';
import 'package:video_chat/provider/chat_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/gift_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/tags_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

class UserProfile extends StatefulWidget {
  final bool? isPopUp;
  int? id;
  UserModel? userModel;

  UserProfile({Key? key, this.isPopUp, @required this.userModel, this.id = 0})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int currentIndex = 0;
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    getTags();
    getDataFromApi();
  }

  getDataFromApi() async {
    widget.userModel = await Provider.of<ChatProvider>(context, listen: false)
        .getUserProfile(
            widget.id != 0 ? widget.id ?? 0 : widget.userModel?.id ?? 0,
            context);
    Provider.of<GiftProvider>(context, listen: false)
        .fetchReceivedGift(context, widget.userModel?.id ?? 0);
    setState(() {});
  }

  getTags() async {
    var provider = Provider.of<TagsProvider>(context, listen: false);

    await provider.fetchTags(context, widget.userModel?.id ?? 0);

    for (var item in provider.tagsList) {
      if (provider.checkFeedBackTagExist(item.id ?? 0)) {
        selectedTags.add(item.id.toString());
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // bottomSheet: widget.isPopUp == true ? SizedBox() : getBottomButton(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            getNaviagtion(),
            SizedBox(
              height: getSize(20),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: getSize(35), right: getSize(35), bottom: getSize(14)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getProfile(),
                    SizedBox(
                      height: getSize(24),
                    ),
                    getCounts(),
                    SizedBox(
                      height: getSize(22),
                    ),
                    getUserDetail(),
                    SizedBox(
                      height: getSize(30),
                    ),
                    getHeaderTitle("Gift"),
                    SizedBox(
                      height: getSize(8),
                    ),
                    getGift(),
                    SizedBox(
                      height: getSize(8),
                    ),
                    getHeaderTitle("Feedback"),
                    SizedBox(
                      height: getSize(10),
                    ),
                    getFeedback(),
                    SizedBox(
                      height: getSize(widget.isPopUp == true ? 20 : 0),
                    ),
                    widget.isPopUp == true ? getBottomButton() : SizedBox()
                  ],
                ),
              ),
            )),
            widget.isPopUp == true ? SizedBox() : getBottomButton()
          ],
        ),
      ),
    );
  }

  //Bottom Sheet
  Widget getBottomButton() {
    UserModel? model = Provider.of<FollowesProvider>(
            navigationKey.currentContext!,
            listen: false)
        .userModel;
    return Padding(
      padding: EdgeInsets.only(
          left: getSize(widget.isPopUp == true ? 0 : 35),
          bottom: getSize(widget.isPopUp == true ? 0 : 26),
          top: getSize(widget.isPopUp == true ? 0 : 10),
          right: getSize(widget.isPopUp == true ? 0 : 35)),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .startChat(widget.userModel?.id ?? 0, context, true);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.button,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: getSize(27),
                      right: getSize(27),
                      top: getSize(17),
                      bottom: getSize(17)),
                  child: Image.asset(
                    icChatWhite,
                    width: getSize(18),
                    height: getSize(18),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: getSize(8),
            ),
            SafeOnTap(
              intervalMs: 2000,
              onSafeTap: ()  async {
                await Provider.of<MatchingProfileProvider>(context,
                    listen: false)
                    .checkCoinBalance(context, widget.userModel?.id ?? 0,
                    widget.userModel?.userName ?? "");

                CoinModel? coins = Provider.of<MatchingProfileProvider>(
                    context,
                    listen: false)
                    .coinBalance;

                if (coins?.lowBalance == false) {
                  // discover.id = 41;
                  await Provider.of<MatchingProfileProvider>(context,
                      listen: false)
                      .startVideoCall(context, widget.userModel?.id ?? 0);
                  VideoCallModel? videoCallModel =
                      Provider.of<MatchingProfileProvider>(context,
                          listen: false)
                          .videoCallModel;

                  if (videoCallModel != null) {
                    // videoCallModel.toUserId = 41;
                    AgoraService.instance.sendVideoCallMessage(
                        videoCallModel.toUserId.toString(),
                        videoCallModel.sessionId ?? "",
                        videoCallModel.channelName ?? "",
                        widget.userModel?.gender ?? "",
                        context);
                    Provider.of<VideoCallStatusProvider>(context,
                        listen: false)
                        .setCallStatus = CallStatus.Start;
                    UserModel? userModel =
                        Provider.of<FollowesProvider>(context, listen: false)
                            .userModel;
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MatchedProfile(
                        channelName: videoCallModel.channelName ?? "",
                        token: videoCallModel.sessionId ?? "",
                        fromId: videoCallModel.fromUserId.toString(),
                        fromImageUrl: (userModel?.userImages?.isEmpty ?? true)
                            ? ""
                            : userModel?.userImages?.first.photoUrl ?? "",
                        name: widget.userModel?.userName ?? "",
                        toImageUrl: (widget.userModel?.userImages?.isEmpty ??
                            true)
                            ? ""
                            : widget.userModel?.userImages?.first.photoUrl ??
                            "",
                        id: videoCallModel.toUserId.toString(),
                        toGender: widget.userModel?.gender ?? "",
                      ),
                    ));
                  }
                } else if (coins?.lowBalance == true) {
                  InAppPurchaseHelper.instance.openCoinPurchasePopUp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: fromHex("#00DE9B"),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: getSize(27),
                      right: getSize(27),
                      top: getSize(17),
                      bottom: getSize(17)),
                  child: Row(
                    children: [
                      Image.asset(
                        icCall,
                        color: Colors.white,
                        width: getSize(18),
                        height: getSize(18),
                      ),
                      (model?.isInfluencer ?? false) == false
                          ? SizedBox(
                              width: getSize(16),
                            )
                          : SizedBox(),
                      (model?.isInfluencer ?? false) == false
                          ? Text(
                              "${widget.userModel?.callRate ?? 0} Coins/minute",
                              style: appTheme?.white16Normal
                                  .copyWith(fontWeight: FontWeight.w600),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //FeedBack
  Widget getFeedback() {
    return Consumer<TagsProvider>(
      builder: (context, tagsProvider, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tagsProvider.userFeedBack.length == 0
              ? Text("Feedback not received",
                  style: TextStyle(color: Colors.white))
              : SimpleTags(
                  content: tagsProvider.userFeedBack
                      .map((e) => e.tag?.name ?? "")
                      .toList(),
                  wrapSpacing: getSize(6),
                  wrapRunSpacing: getSize(20),
                  onTagPress: (tag) {},
                  onTagLongPress: (tag) {},
                  onTagDoubleTap: (tag) {},
                  tagContainerPadding: EdgeInsets.all(10),
                  tagTextStyle: appTheme!.black12Normal.copyWith(
                      fontWeight: FontWeight.w500, color: ColorConstants.red),

                  tagContainerDecoration: BoxDecoration(
                    color: fromHex("#FFDFDF"),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ), // This trailing comma makes auto-formatting nicer for build methods.
                )
        ],
      ),
    );
  }

//Gift
  Widget getGift() {
    return Consumer<GiftProvider>(
      builder: (context, giftProvider, child) {
        return giftProvider.receivedList.length > 0
            ? GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                shrinkWrap: true,
                itemCount: giftProvider.receivedList.length,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return getGiftItem(giftProvider.receivedList[index]);
                })
            : Text("Gift not received.");
      },
    );
  }

  Widget getGiftItem(ReceivedGiftModel model) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: model.gift?.imageUrl ?? "",
          width: getSize(45),
          height: getSize(45),
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Image.asset(
            noAttachment,
            fit: BoxFit.cover,
            height: getSize(45),
            width: getSize(45),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          "X" + (model.count?.toString() ?? ""),
          style: appTheme?.black_Medium_14Text.copyWith(color: Colors.white),
        )
      ],
    );
  }

  //User Detail

  Widget getUserDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: getHeaderTitle(widget.userModel?.userName ?? "")),
            SizedBox(
              width: getSize(10),
            ),
            (widget.userModel?.totalPoint != null &&
                    double.parse(widget.userModel?.totalPoint ?? "") > 0)
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConstants.red),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: getSize(10),
                          right: getSize(10),
                          top: getSize(2),
                          bottom: getSize(2)),
                      child: Text(
                        widget.userModel?.totalPoint ?? '0',
                        style: appTheme?.white12Normal,
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
        SizedBox(
          height: getSize(4),
        ),
        Row(
          children: [
            Text(
              "ID : ${widget.userModel?.id ?? 0}",
              style:
                  appTheme?.black16Medium.copyWith(color: fromHex("#696968")),
            ),
            SizedBox(
              width: getSize(8),
            ),
            // (widget.userModel?.callRate != null &&
            //         (widget.userModel?.callRate ?? 0) > 0)
            //     ? Container(
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10),
            //             color: fromHex("#FFC1C1")),
            //         child: Padding(
            //           padding: EdgeInsets.only(
            //               left: getSize(6),
            //               top: getSize(6),
            //               bottom: getSize(6),
            //               right: getSize(6)),
            //           child: Row(
            //             children: [
            //               Image.asset(
            //                 icCall,
            //                 height: 16,
            //               ),
            //               SizedBox(
            //                 width: getSize(6),
            //               ),
            //               Text(
            //                 widget.userModel?.callRate?.toString() ?? "",
            //                 style: appTheme?.black12Normal
            //                     .copyWith(color: ColorConstants.redText),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     : SizedBox()
          ],
        ),
        SizedBox(
          height: getSize(4),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (widget.userModel?.region?.regionFlagUrl?.isEmpty ?? true)
                ? Container()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(getSize(12)),
                    child: CachedNetworkImage(
                      imageUrl: widget.userModel?.region?.regionFlagUrl ?? "",
                      height: getSize(16),
                      width: getSize(16),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/Profile/no_image.png",
                        height: getSize(16),
                        width: getSize(16),
                      ),
                    ),
                  ),
            (widget.userModel?.region?.regionFlagUrl?.isEmpty ?? true)
                ? Container()
                : SizedBox(
                    width: getSize(6),
                  ),
            Text(
              widget.userModel?.countryIp ?? "",
              style: appTheme?.black14Normal.copyWith(
                  fontSize: getSize(18),
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
        SizedBox(
          height: getSize(28),
        ),
        getHeaderTitle("About me"),
        SizedBox(
          height: getSize(9),
        ),
        Text(
          widget.userModel?.about ?? "-",
          style: appTheme?.black_Medium_14Text.copyWith(color: Colors.white),
        )
      ],
    );
  }

  //Count
  Widget getCounts() {
    return Row(
      children: [
        Expanded(
          child: getCountItem((widget.userModel?.userFollowers ?? 0).toString(),
              "Followers", () {}),
        ),
        SizedBox(width: 15),
        Expanded(
          child: getCountItem(
              (widget.userModel?.byUserUserFollowers ?? 0).toString(),
              "Following",
              () {}),
        ),
        SizedBox(width: 15),
        Expanded(
            child: getCountItem(
                (widget.userModel?.userVisiteds ?? 0).toString(),
                "Visitor",
                () {})),
      ],
    );
  }

  Widget getCountItem(String count, String title, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Container(
        width: getSize(110),
        decoration: BoxDecoration(
            color: ColorConstants.grayBackGround,
            borderRadius: BorderRadius.circular(9)),
        child: Padding(
          padding: EdgeInsets.only(
              // left: getSize(22),
              // right: getSize(22),
              top: getSize(15),
              bottom: getSize(15)),
          child: Column(
            children: [
              Text(
                count,
                style: appTheme?.black16Bold.copyWith(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.redText),
              ),
              SizedBox(
                height: getSize(4),
              ),
              Text(
                title,
                style: appTheme?.black16Bold.copyWith(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Profile
  Widget getProfile() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: getSize(36)),
          child: Container(
            height: getSize(300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(getSize(15)),
              child: ProfileSlider(
                images: widget.userModel?.userImages
                        ?.map((e) => e.photoUrl)
                        .toList() ??
                    [],
                gender: widget.userModel?.gender ?? "",
                scroll: (index) {
                  currentIndex = index;
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        Positioned(
            left: getSize(10),
            bottom: getSize(140),
            child: Column(
              children: List.generate(
                  widget.userModel?.userImages?.length ?? 0,
                  (index) =>
                      pageIndexIndicator(currentIndex == index ? true : false)),
            )),
        Positioned(
            bottom: 0,
            left: getSize(120),
            child: Container(
              width: getSize(110),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        if (widget.userModel?.id != null) {
                          if (((widget.userModel?.userFollowers != null) &&
                              (widget.userModel?.isFollowing == false))) {
                            Provider.of<FollowesProvider>(context,
                                    listen: false)
                                .followUser(context, widget.userModel?.id ?? 0);
                            if (mounted) {
                              setState(() {
                                if (widget.userModel?.userFollowers != null) {
                                  widget.userModel?.isFollowing = true;
                                  widget.userModel?.userFollowers =
                                      (widget.userModel?.userFollowers ?? 0) +
                                          1;
                                }
                              });
                            }
                          } else {
                            Provider.of<FollowesProvider>(context,
                                    listen: false)
                                .unfollowUser(
                                    context, widget.userModel?.id ?? 0);
                            if (mounted) {
                              setState(() {
                                if (widget.userModel?.userFollowers != null) {
                                  widget.userModel?.isFollowing = false;
                                  widget.userModel?.userFollowers =
                                      (widget.userModel?.userFollowers ?? 0) -
                                          1;
                                }
                              });
                            }
                          }
                        }
                      },
                      child: getProfileButton(
                          ((widget.userModel?.userFollowers != null) &&
                                  (widget.userModel?.isFollowing == true))
                              ? "assets/Profile/remove_user.png"
                              : icFollow)),
                  // Spacer(),
                  // Container(
                  //   // height: getSize(72),
                  //   // width: getSize(72),
                  //   decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(
                  //             color: Colors.grey.shade100,
                  //             blurRadius: 0,
                  //             spreadRadius: 2,
                  //             offset: Offset(0, 3)),
                  //       ],
                  //       borderRadius: BorderRadius.circular(getSize(22)),
                  //       color: Colors.white),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(getSize(20)),
                  //     child: Image.asset(
                  //       icHeartProfile,
                  //       width: getSize(36),
                  //       height: getSize(36),
                  //     ),
                  //   ),
                  // ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        if (widget.userModel?.id != null) {
                          if (((widget.userModel?.isFavourite != null) &&
                              (widget.userModel?.isFavourite == false))) {
                            Provider.of<FollowesProvider>(context,
                                    listen: false)
                                .favouriteUnfavouriteUser(
                                    context,
                                    widget.userModel?.id ?? 0,
                                    FavouriteStatus.add);
                            if (mounted) {
                              setState(() {
                                if (widget.userModel?.userFollowers != null) {
                                  widget.userModel?.isFavourite = true;
                                }
                              });
                            }
                          } else {
                            Provider.of<FollowesProvider>(context,
                                    listen: false)
                                .favouriteUnfavouriteUser(
                                    context,
                                    widget.userModel?.id ?? 0,
                                    FavouriteStatus.delete);
                            if (mounted) {
                              setState(() {
                                if (widget.userModel?.isFavourite != null) {
                                  widget.userModel?.isFavourite = false;
                                }
                              });
                            }
                          }
                        }
                      },
                      child: getProfileButton(
                          ((widget.userModel?.isFavourite != null) &&
                                  (widget.userModel?.isFavourite == true))
                              ? "assets/Profile/unfavourite.png"
                              : icFavourite)),
                ],
              ),
            ))
      ],
    );
  }

  Widget getProfileButton(String image) {
    return Container(
        height: getSize(46),
        width: getSize(46),
        decoration: BoxDecoration(
            boxShadow: image == "assets/Profile/remove_user.png" ||
                    image == "assets/Profile/unfavourite.png"
                ? []
                : [
                    BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 0,
                        spreadRadius: 2,
                        offset: Offset(0, 3)),
                  ],
            borderRadius: BorderRadius.circular(getSize(14)),
            color: image == "assets/Profile/remove_user.png" ||
                    image == "assets/Profile/unfavourite.png"
                ? ColorConstants.red
                : Colors.white),
        child: Padding(
          padding: EdgeInsets.all(getSize(11)),
          child: Image.asset(
            image == "assets/Profile/unfavourite.png" ? icFavourite : image,
            color:
                image == "assets/Profile/unfavourite.png" ? Colors.white : null,
            width: getSize(24),
            height: getSize(24),
          ),
        ));
  }

  getNaviagtion() {
    return Row(
      children: [
        getBackButton(context),
        Spacer(),
        getColorText("User", Colors.white, fontSize: getFontSize(18)),
        SizedBox(
          width: getSize(6),
        ),
        getColorText("Profile", ColorConstants.red, fontSize: getFontSize(18)),
        DropdownButton<String>(
          icon: Image.asset(
            icMore,
            width: getSize(18),
            height: getSize(18),
            color: Colors.white,
          ),
          iconSize: 18,
          elevation: 16,
          style: appTheme?.black14Normal,
          underline: Container(
            height: 0,
            color: Colors.white,
          ),
          onChanged: (String? newValue) {
            NavigationUtilities.push(ReportBlock(
              userId: widget.userModel?.id ?? 0,
              reportImageURl:
                  widget.userModel?.userImages?.first.photoUrl ?? "",
              gender: widget.userModel?.gender ?? "",
            ));
          },
          items: <String>['Add to blocklist']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(
          width: getSize(16),
        )
      ],
    );
  }

  Widget getHeaderTitle(String title) {
    return Text(title,
        style: appTheme?.black12Normal.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: getFontSize(20),
            color: Colors.white));
  }

  openBlockConfirmation() {
    showModalBottomSheet(
        isScrollControlled: true,
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
                    left: getSize(35), right: getSize(35), top: getSize(35)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Are you sure you want to block this user?",
                      textAlign: TextAlign.center,
                      style: appTheme?.black14SemiBold
                          .copyWith(fontSize: getFontSize(18)),
                    ),
                    SizedBox(
                      height: getSize(28),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        callApiForBlockUser();
                      },
                      child: Container(
                        height: getSize(52),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorConstants.red, width: 1),
                            color: fromHex("#FFDFDF"),
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                            child: Text("Yes, Block",
                                style: appTheme?.whiteBold32.copyWith(
                                    fontSize: getFontSize(18),
                                    color: ColorConstants.red))),
                      ),
                    ),
                    SizedBox(
                      height: getSize(24),
                    ),
                    getPopBottomButton(context, "No, Keep it", () {
                      Navigator.pop(context);
                    })
                  ],
                ),
              ));
            },
          );
        });
  }

  callApiForBlockUser() {
    // Map<String, dynamic> req = {};
    // req["id"] = widget.userModel.id;

    // NetworkClient.getInstance.showLoader(context);
    // NetworkClient.getInstance.callApi(
    //   context: context,
    //   baseUrl: ApiConstants.apiUrl,
    //   command: ApiConstants.blockUser,
    //   params: req,
    //   headers: NetworkClient.getInstance.getAuthHeaders(),
    //   method: MethodType.Post,
    //   successCallback: (response, message) async {
    //     NetworkClient.getInstance.hideProgressDialog();
    //     await Provider.of<DiscoverProvider>(context, listen: false)
    //         .removeUser(widget.userModel.id);
    //     Navigator.pop(context);
    //   },
    //   failureCallback: (code, message) {
    //     NetworkClient.getInstance.hideProgressDialog();
    //     View.showMessage(context, message);
    //   },
    // );
  }
}
