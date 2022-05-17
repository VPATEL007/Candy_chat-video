import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/components/Model/Chat/videoChatHistoryModel.dart';
// import 'package:video_chat/components/commonWidgets.dart';

import '../../../app/Helper/Themehelper.dart';
import '../../../app/constant/ColorConstant.dart';
import '../../../app/constant/ImageConstant.dart';
import '../../../app/utils/date_utils.dart';
import '../../../app/utils/math_utils.dart';
import '../../../provider/chat_provider.dart';

class VideoChatHistory extends StatefulWidget {
  const VideoChatHistory({Key? key}) : super(key: key);

  @override
  State<VideoChatHistory> createState() => _VideoChatHistoryState();
}

class _VideoChatHistoryState extends State<VideoChatHistory> {
  TextEditingController search = TextEditingController();
  int page = 1;

  @override
  void initState() {
    print('init called of VideoChatHistory');
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false)
          .getVideoChatHistory(context, page: page);
    });
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

  Widget searchUserList() {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      List<VideoChatHistoryResult> chatHistory = chatProvider.videoChatList;
      print(chatHistory.length);
      String noContentLabel = 'No search data found';
      return (chatHistory.isEmpty)
          ? Center(
              child: InkWell(
                onTap: () {
                  Provider.of<ChatProvider>(context, listen: false)
                      .getVideoChatHistory(context, page: page);
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
              itemCount: chatHistory.length,
              itemBuilder: (BuildContext context, int index) {
                String day = '';
                var difference = DateUtilities().calculateDifference(
                    DateTime.parse(chatHistory[index].startedOn ?? ''));
                print('difference==> $difference');
                var date = DateUtilities().getFormattedDateString(
                    DateTime.parse(chatHistory[index].startedOn ?? ''),
                    formatter: 'dd-MM-yyyy hh:mm a');
                if (difference == 0) {
                  day = 'Today';
                  date = DateUtilities().getFormattedDateString(
                      DateTime.parse(chatHistory[index].startedOn ?? ''),
                      formatter: 'h:mm a');
                } else if (difference == -1) {
                  day = 'Yesterday';
                  date = DateUtilities().getFormattedDateString(
                      DateTime.parse(chatHistory[index].startedOn ?? ''),
                      formatter: 'h:mm a');
                }

                return LazyLoadingList(
                    initialSizeOfItems: 20,
                    index: index,
                    hasMore: true,
                    loadMore: () {
                      page++;
                      print(
                          "--------========================= Lazy Loading $page ==========================---------");
                      Provider.of<ChatProvider>(context, listen: false)
                          .getVideoChatHistory(context, page: page);
                    },
                    child:
                        cellItem(chatHistory[index], chatProvider, date, day));
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: getSize(15),
                );
              },
            );
    });
  }

  Widget cellItem(VideoChatHistoryResult videoChatHistoryData,
      ChatProvider chatProvider, date, day) {
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: videoChatHistoryData.photoUrl == ''
                        ? ""
                        : videoChatHistoryData.photoUrl ?? "",
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
                    videoChatHistoryData.userName ?? "",
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
                      videoChatHistoryData.callDurationMins.toString() +
                          ' mins',
                      style: appTheme?.black14Normal.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
                child: SizedBox(
              height: 1.0,
            )),
            Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Column(
                children: [
                  Text(day + '  ' + date,
                      style: TextStyle(
                          fontSize: getFontSize(14),
                          color: Colors.white,
                          fontWeight: FontWeight.normal)),
                  Icon(
                    Icons.videocam,
                    color: ColorConstants.red,
                    size: 32.0,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
