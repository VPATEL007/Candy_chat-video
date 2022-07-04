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

import '../VideoCall/video_history.dart';

class ChatList extends StatefulWidget {
  static const route = "ChatList";

  ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int page = 1;
  int currentIndex = 0;
  List<bool> isMessage = [true, false];
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).getChatList(1, context);
    });
  }

  resetSelectedState() {
    isMessage = [false, false];
  }

  setIndexZero() {
    resetSelectedState();
    print('message selected');
    isMessage[0] = true;
    currentIndex = 0;
    pageController.animateToPage(currentIndex,
        duration: Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
  }

  setIndexOne() {
    resetSelectedState();
    isMessage[1] = true;
    currentIndex = 1;
    pageController.animateToPage(currentIndex,
        duration: Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      bottomNavigationBar: TabBarWidget(
        screen: TabType.Chat,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    setIndexZero();
                  },
                  child: getTabItem('Messages', 0)),
              InkWell(
                  onTap: () {
                    setIndexOne();
                  },
                  child: getTabItem('Video History', 1)),
            ],
          ),
          SizedBox(
            height: getSize(10),
          ),
          Expanded(
            child: Container(
              height: MathUtilities.screenHeight(context) / 1.3,
              child: PageView(
                controller: pageController,
                onPageChanged: (val) {
                  if (val == 0) {
                    setIndexZero();
                  } else {
                    setIndexOne();
                  }
                  currentIndex = val;
                  setState(() {});
                },
                children: [messageUi(), VideoChatHistory()],
              ),
            ),
          ),

          // emptyChat()
        ],
      )),
    );
  }

  Widget messageUi() => Column(
        children: [
          getColorText("Messages", ColorConstants.red),
          Expanded(child: getList())
        ],
      );

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
            style: appTheme?.black14Normal.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: getFontSize(18),
                color: ColorConstants.redText),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.only(left: getSize(30), right: getSize(30)),
            child: Text(
              "No message in your inbox yet! Start chatting with your Randome video chat.",
              textAlign: TextAlign.center,
              style: appTheme?.black14Normal.copyWith(
                  fontWeight: FontWeight.w500, color: ColorConstants.redText),
            ),
          )
        ],
      ),
    );
  }

  getList() {
    return Consumer<ChatProvider>(
      builder: (context, chatHistory, child) => (chatHistory.chatList.isEmpty)
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
                            toUserId: chatHistory.chatList[index].user?.id ?? 0,
                            isFromProfile: false,
                          ));
                        },
                        child:
                            getChatItem(chatHistory.chatList[index], index)));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: getSize(4), bottom: getSize(4)),
                  child: Container(
                    height: 0,
                    color: ColorConstants.borderColor,
                  ),
                );
              },
            ),
    );
  }

  Widget getTabItem(String title, index) {
    return Container(
      width: MathUtilities.screenWidth(context) / 2,
      child: Column(
        children: [
          Text(
            title,
            style: appTheme?.black14SemiBold.copyWith(
                fontSize: getFontSize(16),
                color: isMessage[index] == true
                    ? ColorConstants.redText
                    : Colors.white),
          ),
          SizedBox(
            height: getSize(12),
          ),
          Container(
              height: 1,
              color: isMessage[index] == true
                  ? ColorConstants.redText
                  : Colors.white,
              width: MathUtilities.screenWidth(context) / 2)
        ],
      ),
    );
  }

  Widget getChatItem(ChatListData model, index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: fromHex('#121212')),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(52),
                    child: CachedNetworkImage(
                      imageUrl: model.userImages?.isNotEmpty ?? false
                          ? model.userImages![0].photoUrl ?? ''
                          : '',
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
                      color: (model.user?.onlineStatus ?? offline) == online
                          ? fromHex("#50F5C3")
                          : fromHex("#F55050"),
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
                  model.user?.userName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: appTheme?.black16Bold
                      .copyWith(fontSize: getFontSize(14), color: Colors.white),
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
                  style: appTheme?.black12Normal.copyWith(color: Colors.white),
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
                      style: appTheme?.white12Normal,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
