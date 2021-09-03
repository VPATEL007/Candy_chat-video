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
import 'package:video_chat/components/Model/BlockList/blocklistModel.dart';
import 'package:video_chat/provider/chat_provider.dart';
import 'package:video_chat/provider/report_and_block_provider.dart';

class BlockList extends StatefulWidget {
  BlockList({Key key}) : super(key: key);

  @override
  _BlockListState createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {
  int page = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportAndBlockProvider>(context, listen: false)
          .getBlockList(1, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Block List",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SafeArea(child: getList()),
    );
  }

  getList() {
    return Consumer<ReportAndBlockProvider>(
      builder: (context, blockHistory, child) =>
          (blockHistory?.blockList?.isEmpty ?? true)
              ? Center(
                  child: Text(
                    "No Block List Found! ",
                    style: appTheme.black14Normal.copyWith(
                        fontSize: getFontSize(16), fontWeight: FontWeight.w700),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(
                      top: getSize(20), left: getSize(25), right: getSize(25)),
                  itemCount: blockHistory.blockList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LazyLoadingList(
                        initialSizeOfItems: 20,
                        index: index,
                        hasMore: true,
                        loadMore: () {
                          page++;
                          print(
                              "--------========================= Lazy Loading $page ==========================---------");

                          Provider.of<ReportAndBlockProvider>(context,
                                  listen: false)
                              .getBlockList(page, context);
                        },
                        child: InkWell(
                            onTap: () {},
                            child: cellItem(blockHistory.blockList[index])));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: getSize(15),
                    );
                  },
                ),
    );
  }

  Widget cellItem(BlockListModel model) {
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
                  imageUrl: model?.user?.photoUrl ?? "",
                  height: getSize(48),
                  width: getSize(51),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    getUserPlaceHolder(model.user?.gender ?? ""),
                    height: getSize(48),
                    width: getSize(51),
                  ),
                )),
            SizedBox(
              width: getSize(11),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.user?.userName ?? "",
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
                        model.user?.countryIp ?? "",
                        style: appTheme.black14Normal
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Provider.of<ReportAndBlockProvider>(context, listen: false)
                    .unBlockUser(model.user.id, context);
              },
              child: Text(
                "Unblock",
                style: appTheme.black12Normal.copyWith(
                    color: ColorConstants.redText, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
