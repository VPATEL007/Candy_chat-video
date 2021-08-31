import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/provider/chat_provider.dart';

import '../../../app/app.export.dart';

class Chat extends StatefulWidget {
  final String channelId;
  final int toUserId;

  Chat({Key key, @required this.channelId, @required this.toUserId})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();
  AgoraService agoraService = AgoraService.instance;
  List<MessageObj> _chatsList = [];
  ScrollController messageListScrollController = ScrollController();
  String userId = app.resolve<PrefUtils>().getUserDetails()?.id.toString();
  UserModel toUser;

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getToUserDetail();
    });
  }

  getToUserDetail() async {
    toUser = await Provider.of<ChatProvider>(context, listen: false)
        .getUserProfile(widget.toUserId, context);
    setState(() {});
  }

  Future<void> init() async {
    agoraService.joinChannel((widget?.channelId ?? ""),
        onMemberJoined: (AgoraRtmMember member) {
      print(
          "Member joined: " + member.userId + ', channel: ' + member.channelId);
    }, onMemberLeft: (AgoraRtmMember member) {
      print("Member left: " + member.userId + ', channel: ' + member.channelId);
    }, onMessageReceived: (AgoraRtmMessage message, AgoraRtmMember member) {
      MessageObj _chat = MessageObj(
          chatDate: DateTime.now(),
          message: message.text,
          isSendByMe: member.userId.toString().toLowerCase() ==
              userId.toLowerCase().toLowerCase(),
          sendBy: member.userId);

      _chatsList.add(_chat);
      if (mounted) setState(() {});
      print("Channel msg: " + member.userId + ", msg: " + (message.text ?? ""));
    });
  }

  @override
  void dispose() {
    super.dispose();
    agoraService?.leaveChannel();
    // agoraService?.logOut();
    messageListScrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBar(context, toUser?.userName ?? "",
            isWhite: true,
            centerTitle: false,
            leadingButton: getBackButton(context),
            actionItems: [
              Padding(
                padding: EdgeInsets.only(top: getSize(20), right: getSize(6)),
                child: Text("• Online",
                    style: appTheme.black_Medium_16Text
                        .copyWith(color: fromHex("#00DE9B"))),
              ),
              getBarButton(context, icCall, () {}),
              InkWell(
                onTap: () async {
                  if (toUser != null) {
                    NavigationUtilities.push(UserProfile(userModel: toUser));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(getSize(14)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: CachedNetworkImage(
                        imageUrl: toUser?.getUserImage() ?? "",
                        width: getSize(28),
                        height: getSize(26),
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.4),
                        colorBlendMode: BlendMode.overlay,
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/Profile/no_image.png"),
                      )),
                ),
              )
            ]),
        bottomSheet: chatTextFiled(),
        body: chatList(),
      ),
    );
  }

  Widget chatList() {
    return StreamBuilder<List<ChatObj>>(
        stream: Stream.value(sortChatByDate(_chatsList)),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: appTheme.black14Normal,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data?.isEmpty ?? true) {
            return emptyChat();
          } else {
            return ListView.builder(
              reverse: true,
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: getSize(20), bottom: getSize(120)),
              controller: messageListScrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                List<MessageObj> msgObjList = [];

                if (index != snapshot.data.length) {
                  msgObjList = snapshot.data[index].messageObjList;
                }
                return snapshot.data.isEmpty
                    ? Container()
                    : StickyHeader(
                        // Header...
                        header: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: fromHex("#F1F1F1")),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: getSize(7),
                                  bottom: getSize(7),
                                  left: getSize(20),
                                  right: getSize(20)),
                              child: Text(
                                snapshot.data[index].getChatingDates,
                                style: appTheme.black12Normal,
                              ),
                            ),
                          ),
                        ),
                        // Content...
                        content: _buildChats(snapshot.data[index], msgObjList),
                      );
              },
            );
          }
        });
  }

  // Chat date and chats...
  Widget _buildChats(ChatObj chat, List<MessageObj> messageList) {
    return ListView.builder(
      reverse: true,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10),
      physics: NeverScrollableScrollPhysics(),
      itemCount: messageList.length,
      itemBuilder: (context, contentIndex) {
        return getChatItem(
          messageList[contentIndex],
        );
      },
    );
  }

  Widget getChatItem(MessageObj messageList) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 0),
      child: Align(
        alignment:
            !messageList.isSendByMe ? Alignment.topLeft : Alignment.topRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: !messageList.isSendByMe
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 0, maxWidth: getSize(260)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                          getSize(!messageList.isSendByMe ? 16 : 0)),
                      topLeft: Radius.circular(
                          getSize(messageList.isSendByMe ? 16 : 0)),
                      bottomLeft: Radius.circular(getSize(16)),
                      bottomRight: Radius.circular(getSize(16))),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: messageList.isSendByMe
                        ? [ColorConstants.gradiantStart, ColorConstants.red]
                        : [fromHex("#F1F1F1"), fromHex("#F1F1F1")],
                  )),
              padding: EdgeInsets.all(16),
              child: Text(
                messageList?.message,
                style: appTheme.black12Normal.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        messageList.isSendByMe ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(
              height: getSize(6),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                messageList.getChatDate,
                textAlign: messageList.sendBy != userId
                    ? TextAlign.left
                    : TextAlign.right,
                style: appTheme.black12Normal.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFC2C2C2),
                    fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }

//ChatTextFiled
  Widget chatTextFiled() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chatsList?.isEmpty
            ? Container(
                height: getSize(38),
                child: ListView.separated(
                    padding:
                        EdgeInsets.only(left: getSize(25), right: getSize(25)),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          decoration: BoxDecoration(
                            color: fromHex("#F1F1F1"),
                            border: Border.all(
                                color: ColorConstants.borderColor, width: 1),
                            borderRadius: BorderRadius.circular(
                              getSize(19),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: getSize(20),
                                right: getSize(20),
                                top: getSize(10),
                                bottom: getSize(10)),
                            child: Text(
                              "Say hii",
                              style: appTheme.black12Normal
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: getSize(12),
                      );
                    }),
              )
            : SizedBox(),
        SizedBox(height: 15),
        Container(
          color: fromHex("#F7F7F7"),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: getSize(26), left: getSize(20)),
                  child: CommonTextfield(
                    textOption: TextFieldOption(
                        radious: getSize(26),
                        hintText: "Type something....",
                        maxLine: 1,
                        fillColor: fromHex("#F1F1F1"),
                        postfixWid: Padding(
                          padding: EdgeInsets.only(
                              top: getSize(16), right: getSize(16)),
                          child: InkWell(
                            onTap: () async {
                              if (_chatController.text?.isEmpty ?? true) return;
                              MessageObj _chat = MessageObj(
                                  chatDate: DateTime.now(),
                                  message: _chatController.text,
                                  isSendByMe: true,
                                  sendBy: userId);

                              _chatsList.add(_chat);
                              if (mounted) setState(() {});
                              await agoraService
                                  .sendMessage(_chatController.text);

                              _chatController.clear();
                              if (_chatsList?.isNotEmpty ?? false)
                                messageListScrollController?.jumpTo(0.0);
                              if (mounted) setState(() {});
                            },
                            child: Text(
                              "Send",
                              style: appTheme.black14Normal.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstants.red),
                            ),
                          ),
                        ),
                        inputController: _chatController),
                    textCallback: (text) {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: getSize(26), left: getSize(20), right: getSize(20)),
                child: Image.asset(
                  icGift,
                  height: getSize(32),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

//Empty Chat
  Widget emptyChat() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Start your conversation with",
          style: appTheme.black14Normal
              .copyWith(fontWeight: FontWeight.w700, fontSize: getFontSize(18)),
        ),
        SizedBox(
          height: getSize(14),
        ),
        Text(
          "a simple wave, maybe?",
          style: appTheme.black14Normal
              .copyWith(fontWeight: FontWeight.w500, fontSize: getFontSize(18)),
        ),
        SizedBox(
          height: getSize(26),
        ),
        Stack(
          children: [
            Align(
              child: Image.asset(
                icEmptyChat,
                height: getSize(270),
                width: getSize(287),
              ),
            ),
            Container(
              width: MathUtilities.screenWidth(context),
              height: getSize(270),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    icWavingHand,
                    height: getSize(54),
                  ),
                  SizedBox(
                    height: getSize(10),
                  ),
                  Text(
                    "Say hi to",
                    style: appTheme.black14Normal.copyWith(
                        fontSize: getSize(16), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: getSize(4),
                  ),
                  Text(
                    "Leon Hunt",
                    style: appTheme.black14Normal.copyWith(
                        fontSize: getSize(16), fontWeight: FontWeight.w700),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  // Get Sorted List By Chat dates...
  List<ChatObj> sortChatByDate(List<MessageObj> chatList) {
    List<ChatObj> tempArray = [];
    chatList.forEach((chats) {
      //Get list Index...
      int transIndex = tempArray.indexWhere((item) {
        return DateFormat('dd MMMM yyyy').format(item.chatDate) ==
            DateFormat('dd MMMM yyyy')
                .format(chats.chatDate); //Sort by List Category...
      });
      //Check If Project Already Added, if added then add category and list in same project...
      if (transIndex >= 0) {
        tempArray[transIndex].messageObjList.insert(0, chats);
      } else {
        //New Temp List...
        ChatObj tempList = ChatObj();
        tempList.chatDate = chats.chatDate; // List Name...
        tempList.messageObjList = [chats];

        tempArray.add(tempList);
      }
    });

    return tempArray;
  }
}
