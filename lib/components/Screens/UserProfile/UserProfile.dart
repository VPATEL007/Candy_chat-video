import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/Reportblock.dart';
import 'package:video_chat/components/widgets/ProfileSlider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/tags_provider.dart';

class UserProfile extends StatefulWidget {
  final bool isPopUp;
  final UserModel userModel;
  UserProfile({Key key, this.isPopUp, @required this.userModel})
      : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomSheet: widget.isPopUp == true ? SizedBox() : getBottomButton(),
      body: SafeArea(
        child: Column(
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
    return Padding(
      padding: EdgeInsets.only(
          left: getSize(widget.isPopUp == true ? 0 : 35),
          bottom: getSize(widget.isPopUp == true ? 0 : 26),
          top: getSize(widget.isPopUp == true ? 0 : 10),
          right: getSize(widget.isPopUp == true ? 0 : 35)),
      child: Container(
        child: Row(
          children: [
            Container(
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
            SizedBox(
              width: getSize(8),
            ),
            Container(
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
                child: Row(
                  children: [
                    Image.asset(
                      icCall,
                      color: Colors.white,
                      width: getSize(18),
                      height: getSize(18),
                    ),
                    SizedBox(
                      width: getSize(16),
                    ),
                    Text(
                      "${widget.userModel?.callRate ?? 0} Token/minute",
                      style: appTheme.white16Normal
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //FeedBack
  Widget getFeedback() {
    return Consumer<TagsProvider>(
      builder: (context, tagsProvider, child) => Tags(
          itemCount: tagsProvider.tagsList.length,
          spacing: getSize(6),
          runSpacing: getSize(20),
          alignment: WrapAlignment.center,
          itemBuilder: (int index) {
            return ItemTags(
              active: true,
              pressEnabled: false,
              activeColor: fromHex("#FFDFDF"),
              title: tagsProvider.tagsList[index]?.tag ?? "",
              index: index,
              textStyle:
                  appTheme.black12Normal.copyWith(fontWeight: FontWeight.w500),
              textColor: Colors.black,
              textActiveColor: ColorConstants.red,
              color: fromHex("#F1F1F1"),
              elevation: 0,
              borderRadius: BorderRadius.circular(6),
              padding: EdgeInsets.only(
                  left: getSize(14),
                  right: getSize(14),
                  top: getSize(7),
                  bottom: getSize(7)),
            );
          }),
    );
  }

//Gift
  Widget getGift() {
    return GridView.builder(
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        shrinkWrap: true,
        itemCount: 7,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          return getGiftItem();
        });
  }

  Widget getGiftItem() {
    return Column(
      children: [
        Image.asset(
          icGiftCoin,
          height: getSize(50),
        ),
        Text(
          "x15",
          style: appTheme.black_Medium_14Text,
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
            getHeaderTitle(widget.userModel?.userName ?? ""),
            SizedBox(
              width: getSize(10),
            ),
            Container(
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
                  style: appTheme.white12Normal,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: getSize(4),
        ),
        Row(
          children: [
            Text(
              "ID : ${widget.userModel?.id}",
              style: appTheme.black16Medium.copyWith(color: fromHex("#696968")),
            ),
            SizedBox(
              width: getSize(8),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: fromHex("#FFC1C1")),
              child: Padding(
                padding: EdgeInsets.only(
                    left: getSize(6),
                    top: getSize(6),
                    bottom: getSize(6),
                    right: getSize(6)),
                child: Row(
                  children: [
                    Image.asset(
                      icCall,
                      height: 16,
                    ),
                    SizedBox(
                      width: getSize(6),
                    ),
                    Text(
                      "100%",
                      style: appTheme.black12Normal
                          .copyWith(color: ColorConstants.redText),
                    )
                  ],
                ),
              ),
            )
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
                      imageUrl: widget.userModel?.region?.regionFlagUrl,
                      height: getSize(16),
                      width: getSize(16),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                         Image.asset("assets/Profile/no_image.png"),
                    ),
                  ),
            (widget.userModel?.region?.regionFlagUrl?.isEmpty ?? true)
                ? Container()
                : SizedBox(
                    width: getSize(6),
                  ),
            Text(
              widget.userModel?.region?.regionName ?? "",
              style: appTheme.black14Normal.copyWith(
                fontSize: getSize(18),
                fontWeight: FontWeight.w500,
              ),
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
          style: appTheme.black_Medium_14Text,
        )
      ],
    );
  }

  //Count
  Widget getCounts() {
    return Center(
      child: Container(
        child: Row(
          children: [
            getCountItem(
                widget.userModel?.userFollowers?.first?.followersCount
                    ?.toString(),
                "Followers",
                () {}),
            Spacer(),
            getCountItem(
                (widget.userModel?.byUserUserFollowers?.isEmpty ?? true)
                    ? "0"
                    : widget
                        .userModel?.byUserUserFollowers?.first?.followersCount
                        ?.toString(),
                "Following",
                () {}),
            Spacer(),
            getCountItem("251", "Fans", () {}),
          ],
        ),
      ),
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
            color: fromHex("#F7F7F7"), borderRadius: BorderRadius.circular(9)),
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
                style: appTheme.black16Bold.copyWith(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.redText),
              ),
              SizedBox(
                height: getSize(4),
              ),
              Text(
                title,
                style: appTheme.black16Bold.copyWith(
                    fontSize: getFontSize(16), fontWeight: FontWeight.w600),
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
                        ?.toList() ??
                    [],
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
                  widget.userModel?.userImages?.length,
                  (index) =>
                      pageIndexIndicator(currentIndex == index ? true : false)),
            )),
        Positioned(
            bottom: 0,
            left: getSize(62),
            child: Container(
              width: getSize(220),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        if (widget.userModel.id != null)
                          Provider.of<FollowesProvider>(context, listen: false)
                              .followUser(context, widget.userModel.id);
                        if (mounted) {
                          setState(() {
                            if (widget.userModel?.userFollowers?.isNotEmpty ??
                                false) {
                              widget.userModel.userFollowers.first
                                  .followersCount++;
                            }
                          });
                        }
                      },
                      child: getProfileButton(icFollow)),
                  Spacer(),
                  Container(
                    // height: getSize(72),
                    // width: getSize(72),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 0,
                              spreadRadius: 2,
                              offset: Offset(0, 3)),
                        ],
                        borderRadius: BorderRadius.circular(getSize(22)),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(getSize(20)),
                      child: Image.asset(
                        icHeartProfile,
                        width: getSize(36),
                        height: getSize(36),
                      ),
                    ),
                  ),
                  Spacer(),
                  getProfileButton(icFavourite),
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
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 0,
                  spreadRadius: 2,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(getSize(14)),
            color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(getSize(11)),
          child: Image.asset(
            image,
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
        getColorText("User", Colors.black, fontSize: getFontSize(18)),
        SizedBox(
          width: getSize(6),
        ),
        getColorText("Profile", ColorConstants.red, fontSize: getFontSize(18)),
        DropdownButton<String>(
          icon: Image.asset(
            icMore,
            width: getSize(18),
            height: getSize(18),
          ),
          iconSize: 18,
          elevation: 16,
          style: appTheme.black14Normal,
          underline: Container(
            height: 0,
            color: Colors.white,
          ),
          onChanged: (String newValue) {
            if (newValue == "Report") {
              NavigationUtilities.push(ReportBlock(
                userId: widget.userModel?.id,
                reportImageURl: widget.userModel?.photoUrl ?? "",
              ));
            } else {
              openBlockConfirmation();
            }
          },
          items: <String>['Report', 'Add to blocklist']
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
        style: appTheme.black12Normal.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: getFontSize(20),
        ));
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
                      style: appTheme.black14SemiBold
                          .copyWith(fontSize: getFontSize(18)),
                    ),
                    SizedBox(
                      height: getSize(28),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
                                style: appTheme.whiteBold32.copyWith(
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
}
