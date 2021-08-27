import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/date_utils.dart';
import 'package:video_chat/components/Model/Chat/ChatList.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';
import 'package:video_chat/provider/chat_provider.dart';

class ChatList extends StatefulWidget {
  static const route = "ChatList";
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).getChatList(1, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Chat,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: getSize(10),
          ),
          getColorText("Messages", ColorConstants.red),
          Expanded(child: getList())
          // emptyChat()
        ],
      )),
    );
  }

  //Empty Chat
  Widget emptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icEmptyChatList,
            width: MathUtilities.screenWidth(context) - 150,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No Message, yet",
            style: appTheme.black14Normal.copyWith(
                fontWeight: FontWeight.w600, fontSize: getFontSize(18)),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.only(left: getSize(30), right: getSize(30)),
            child: Text(
              "No message in your inbox yet! Start chatting with your Randome video chat.",
              textAlign: TextAlign.center,
              style:
                  appTheme.black14Normal.copyWith(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  getList() {
    return Consumer<ChatProvider>(
      builder: (context, chatHistory, child) =>
          (chatHistory?.chatList?.isEmpty ?? true)
              ? emptyChat()
              : ListView.separated(
                  padding: EdgeInsets.only(
                      top: getSize(28), left: getSize(25), right: getSize(25)),
                  itemCount: chatHistory.chatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LazyLoadingList(
                        initialSizeOfItems: 20,
                        index: index,
                        hasMore: true,
                        loadMore: () {
                          page++;
                          print(
                              "--------========================= Lazy Loading $page ==========================---------");

                          Provider.of<ChatProvider>(context, listen: false)
                              .getChatList(page, context);
                        },
                        child: InkWell(
                            onTap: () {
                              NavigationUtilities.push(Chat(
                                  channelId:
                                      chatHistory.chatList[index].channelName,
                                  toUserId: chatHistory.chatList[index]
                                      .getToUserId()));
                            },
                            child: getChatItem(chatHistory.chatList[index])));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: getSize(14), bottom: getSize(14)),
                      child: Container(
                        height: 1,
                        color: ColorConstants.borderColor,
                      ),
                    );
                  },
                ),
    );
  }

  Widget getChatItem(ChatListModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(52),
                child: CachedNetworkImage(
                  imageUrl: model.withUser?.getUserImage() ?? "",
                  height: getSize(52),
                  width: getSize(52),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/Profile/no_image.png",
                    height: getSize(48),
                    width: getSize(51),
                  ),
                )),
            Positioned(
              right: getSize(0),
              bottom: getSize(4),
              child: Container(
                height: getSize(10),
                width: getSize(10),
                decoration: BoxDecoration(
                  // color:
                  //     index % 2 == 0 ? fromHex("#50F5C3") : ColorConstants.red,
                  color: fromHex("#50F5C3"),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(
                    getSize(10),
                  ),
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
            SizedBox(height: getSize(2)),
            Text(
              model.withUser?.userName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTheme.black16Bold.copyWith(fontSize: getFontSize(14)),
            ),
            // SizedBox(height: getSize(6)),
            // Text(
            //   "Hi, how are you ? May i get",
            //   style: appTheme.black14Normal,
            //   overflow: TextOverflow.ellipsis,
            // )
          ],
        ),
        Spacer(),
        Column(
          children: [
            SizedBox(height: getSize(2)),
            Text(
              DateUtilities().convertServerDateToFormatterString(
                  model.updatedOn ?? "",
                  formatter: DateUtilities.h_mm_a),
              style: appTheme.black12Normal,
            ),
            SizedBox(
              height: getSize(8),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorConstants.red,
                borderRadius: BorderRadius.circular(
                  getSize(22),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: getSize(8),
                    right: getSize(8),
                    top: getSize(2),
                    bottom: getSize(2)),
                child: Text(
                  "0",
                  style: appTheme.white12Normal,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
