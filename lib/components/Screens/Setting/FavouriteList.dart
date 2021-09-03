import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Model/Favourite/FavouriteListModel.dart';
import 'package:video_chat/provider/favourite_provider.dart';

class FavouriteList extends StatefulWidget {
  FavouriteList({Key key}) : super(key: key);

  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavouriteProvider>(context, listen: false)
          .getFavouriteList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Favourite",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SafeArea(child: getList()),
    );
  }

  getList() {
    return Consumer<FavouriteProvider>(
      builder: (context, favourite, child) =>
          (favourite?.favouriteList?.isEmpty ?? true)
              ? Center(
                  child: Text(
                    "No Favourite Found! ",
                    style: appTheme.black14Normal.copyWith(
                        fontSize: getFontSize(16), fontWeight: FontWeight.w700),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                      top: getSize(20), left: getSize(25), right: getSize(25)),
                  itemCount: favourite.favouriteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LazyLoadingList(
                        initialSizeOfItems: 20,
                        index: index,
                        hasMore: true,
                        loadMore: () {
                          // page++;
                          // print(
                          //     "--------========================= Lazy Loading $page ==========================---------");

                          // Provider.of<ReportAndBlockProvider>(context,
                          //         listen: false)
                          //     .getBlockList(page, context);
                        },
                        child: InkWell(
                            onTap: () {},
                            child: cellItem(favourite.favouriteList[index])));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: getSize(15),
                    );
                  },
                ),
    );
  }

  Widget cellItem(FavouriteListModel model) {
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
                  imageUrl: model?.photoUrl ?? "",
                  height: getSize(48),
                  width: getSize(51),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    getUserPlaceHolder(model.gender ?? ""),
                    height: getSize(48),
                    width: getSize(51),
                  ),
                )),
            SizedBox(
              width: getSize(11),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model?.providerDisplayName ?? "",
                  style: appTheme.black14Normal.copyWith(
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
                      model?.countryIp ?? "",
                      style: appTheme.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
