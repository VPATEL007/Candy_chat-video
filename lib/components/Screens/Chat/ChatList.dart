import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';
import 'package:video_chat/components/widgets/TabBar/Tabbar.dart';

class ChatList extends StatefulWidget {
  static const route = "ChatList";
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
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
          chatList(),
          // emptyChat()
        ],
      )),
    );
  }

  //Empty Chat
  Widget emptyChat() {
    return Center(
      child: Column(
        children: [],
      ),
    );
  }

//Chat List
  Widget chatList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(
            top: getSize(28), left: getSize(25), right: getSize(25)),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                NavigationUtilities.push(Chat());
              },
              child: getChatItem(index));
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: getSize(14), bottom: getSize(14)),
            child: Container(
              height: 1,
              color: ColorConstants.borderColor,
            ),
          );
        },
      ),
    );
  }

  Widget getChatItem(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(52),
              child: Image.asset(
                icTemp,
                height: getSize(52),
                width: getSize(52),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: getSize(0),
              bottom: getSize(4),
              child: Container(
                height: getSize(10),
                width: getSize(10),
                decoration: BoxDecoration(
                  color:
                      index % 2 == 0 ? fromHex("#50F5C3") : ColorConstants.red,
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getSize(2)),
              Text(
                index == 0 ? "Empty Chat" : "Helmi Lutvyandi",
                style: appTheme.black16Bold.copyWith(fontSize: getFontSize(14)),
              ),
              SizedBox(height: getSize(6)),
              Text(
                "Hi, how are you ? May i get",
                style: appTheme.black14Normal,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(height: getSize(2)),
            Text(
              "10:33 PM",
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
                  "10",
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
