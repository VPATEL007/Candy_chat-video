import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sticky_headers/sticky_headers.dart';
import 'package:video_chat/app/Helper/inAppPurchase_service.dart';
import 'package:video_chat/components/Model/Match%20Profile/call_status.dart';
import 'package:video_chat/components/Model/Match%20Profile/video_call.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/MatchedProfile.dart';
import 'package:video_chat/components/Screens/UserProfile/UserProfile.dart';
import 'package:video_chat/provider/chat_provider.dart';
import 'package:video_chat/provider/followes_provider.dart';
import 'package:video_chat/provider/gift_provider.dart';
import 'package:video_chat/provider/matching_profile_provider.dart';
import 'package:video_chat/provider/video_call_status_provider.dart';

import '../../../app/app.export.dart';

class Chat extends StatefulWidget {
  final String channelId;
  final int toUserId;
  final isFromProfile;

  Chat(
      {Key? key,
      required this.channelId,
      required this.toUserId,
      this.isFromProfile = false})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();
  AgoraService agoraService = AgoraService.instance;
  List<MessageObj> _chatsList = [];
  ScrollController messageListScrollController = ScrollController();

  String? userId = app.resolve<PrefUtils>().getUserDetails()?.id.toString();
  UserModel? toUser;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getToUserDetail();
    });
  }

  getToUserDetail() async {
    toUser = await Provider.of<ChatProvider>(context, listen: false)
        .getUserProfile(widget.toUserId, context);
    List<MessageObj> chatsList =
        await Provider.of<ChatProvider>(context, listen: false)
            .getChatMessageHistory(context, widget.channelId,
                DateTime.now().toUtc().toIso8601String());
    _chatsList.addAll(chatsList);
    setState(() {});
  }

  getMessages() async {
    String endDate = DateTime.now().toUtc().toIso8601String();

    if (_chatsList.length > 0) {
      endDate = _chatsList.last.chatDate?.toUtc().toIso8601String() ?? "";
    }

    List<MessageObj> chatsList =
        await Provider.of<ChatProvider>(context, listen: false)
            .getChatMessageHistory(context, widget.channelId, endDate);

    setState(() {
      _refreshController.loadComplete();

      _chatsList.addAll(chatsList);
    });
  }

  Future<void> init() async {
    agoraService.joinChannel((widget.channelId),
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
              userId?.toLowerCase().toLowerCase(),
          sendBy: member.userId);

      _chatsList.add(_chat);
      if (mounted) setState(() {});
      print("Channel msg: " + member.userId + ", msg: " + message.text);
    });
  }

  @override
  void dispose() {
    super.dispose();

    agoraService.leaveChannel();
    messageListScrollController.dispose();
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
        bottomSheet: chatTextFiled(),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    getBackButton(context),
                    Text(toUser?.userName ?? "",
                        style: appTheme?.black_Medium_16Text
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 8,
                    ),
                    Text("• " + (toUser?.onlineStatus ?? offline),
                        style: appTheme?.black_Medium_16Text.copyWith(
                            color: (toUser?.onlineStatus ?? offline) == online
                                ? fromHex("#00DE9B")
                                : fromHex("#F55050"))),
                    Spacer(),
                    getBarButton(context, icCall, () async {
                      if (toUser == null) return;

                      await Provider.of<MatchingProfileProvider>(context,
                              listen: false)
                          .checkCoinBalance(
                              context, toUser?.id ?? 0, toUser?.userName ?? "");

                      CoinModel? coins = Provider.of<MatchingProfileProvider>(
                              context,
                              listen: false)
                          .coinBalance;

                      if (coins?.lowBalance == false) {
                        // discover.id = 41;
                        await Provider.of<MatchingProfileProvider>(context,
                                listen: false)
                            .startVideoCall(context, toUser?.id ?? 0);
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
                              toUser?.gender ?? "",
                              context);
                          Provider.of<VideoCallStatusProvider>(context,
                                  listen: false)
                              .setCallStatus = CallStatus.Start;
                          UserModel? userModel = Provider.of<FollowesProvider>(
                                  context,
                                  listen: false)
                              .userModel;
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MatchedProfile(
                                channelName: videoCallModel.channelName ?? "",
                                token: videoCallModel.sessionId ?? "",
                                fromId: videoCallModel.fromUserId.toString(),
                                fromImageUrl: (userModel?.userImages?.isEmpty ??
                                        true)
                                    ? ""
                                    : userModel?.userImages?.first.photoUrl ??
                                        "",
                                name: toUser?.userName ?? "",
                                toImageUrl: (toUser?.userImages?.isEmpty ??
                                        true)
                                    ? ""
                                    : toUser?.userImages?.first.photoUrl ?? "",
                                id: videoCallModel.toUserId.toString(),
                                toGender: toUser?.gender ?? ""),
                          ));
                        }
                      } else if (coins?.lowBalance == true) {
                        InAppPurchaseHelper.instance.openCoinPurchasePopUp();
                      }
                    }),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      onTap: () {
                        if (toUser != null) {
                          if (widget.isFromProfile)
                            Navigator.pop(context);
                          else
                            NavigationUtilities.push(
                                UserProfile(userModel: toUser));
                        }
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: CachedNetworkImage(
                            imageUrl: toUser?.getUserImage() ?? "",
                            width: getSize(26),
                            height: getSize(26),
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.4),
                            colorBlendMode: BlendMode.overlay,
                            errorWidget: (context, url, error) => Image.asset(
                              getUserPlaceHolder(toUser?.gender ?? ""),
                              height: getSize(26),
                              width: getSize(26),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
              Expanded(child: chatList())
            ],
          ),
        ),
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
                style: appTheme?.black14Normal,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.data?.isEmpty ?? true) {
            return emptyChat();
          } else {
            return SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: () async {},
              onLoading: () async {
                // if (mounted) setState(() {});
                getMessages();
              },
              child: ListView.builder(
                reverse: true,
                itemCount: snapshot.data?.length,
                shrinkWrap: true,
                padding:
                    EdgeInsets.only(top: getSize(20), bottom: getSize(120)),
                controller: messageListScrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<MessageObj>? msgObjList = [];

                  if (index != snapshot.data?.length) {
                    msgObjList = snapshot.data?[index].messageObjList;
                  }
                  return snapshot.data?.isEmpty ?? true
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
                                  snapshot.data?[index].getChatingDates ?? "",
                                  style: appTheme?.black12Normal,
                                ),
                              ),
                            ),
                          ),
                          // Content...
                          content: _buildChats(
                              snapshot.data![index], msgObjList ?? []),
                        );
                },
              ),
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
                messageList.message ?? "",
                style: appTheme?.black12Normal.copyWith(
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
                style: appTheme?.black12Normal.copyWith(
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
        // _chatsList?.isEmpty
        //     ? Container(
        //         height: getSize(38),
        //         child: ListView.separated(
        //             padding:
        //                 EdgeInsets.only(left: getSize(25), right: getSize(25)),
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //             itemCount: 10,
        //             itemBuilder: (BuildContext context, int index) {
        //               return Container(
        //                   decoration: BoxDecoration(
        //                     color: fromHex("#F1F1F1"),
        //                     border: Border.all(
        //                         color: ColorConstants.borderColor, width: 1),
        //                     borderRadius: BorderRadius.circular(
        //                       getSize(19),
        //                     ),
        //                   ),
        //                   child: Padding(
        //                     padding: EdgeInsets.only(
        //                         left: getSize(20),
        //                         right: getSize(20),
        //                         top: getSize(10),
        //                         bottom: getSize(10)),
        //                     child: Text(
        //                       "Say hii",
        //                       style: appTheme.black12Normal
        //                           .copyWith(fontWeight: FontWeight.w500),
        //                     ),
        //                   ));
        //             },
        //             separatorBuilder: (BuildContext context, int index) {
        //               return SizedBox(
        //                 width: getSize(12),
        //               );
        //             }),
        //       )
        //     : SizedBox(),
        // SizedBox(height: 15),
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
                              if (_chatController.text.isEmpty) return;
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
                              if (_chatsList.isNotEmpty)
                                messageListScrollController.jumpTo(0.0);
                              if (mounted) setState(() {});
                            },
                            child: Text(
                              "Send",
                              style: appTheme?.black14Normal.copyWith(
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
                child: InkWell(
                  onTap: () {
                    Provider.of<GiftProvider>(context, listen: false)
                        .openGiftPopUp(widget.toUserId);
                  },
                  child: Image.asset(
                    icGift,
                    height: getSize(32),
                  ),
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
    return Container(
      height: MathUtilities.screenHeight(context) - getSize(180),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Start your conversation with",
            style: appTheme?.black14Normal.copyWith(
                fontWeight: FontWeight.w700, fontSize: getFontSize(18)),
          ),
          SizedBox(
            height: getSize(14),
          ),
          Text(
            "a simple wave, maybe?",
            style: appTheme?.black14Normal.copyWith(
                fontWeight: FontWeight.w500, fontSize: getFontSize(18)),
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
              InkWell(
                onTap: () async {
                  MessageObj _chat = MessageObj(
                      chatDate: DateTime.now(),
                      message: "hi",
                      isSendByMe: true,
                      sendBy: userId);

                  _chatsList.add(_chat);
                  if (mounted) setState(() {});
                  await agoraService.sendMessage("hi");

                  _chatController.clear();
                  if (_chatsList.isNotEmpty)
                    messageListScrollController.jumpTo(0.0);
                  if (mounted) setState(() {});
                },
                child: Container(
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
                        "Say hi",
                        style: appTheme?.black14Normal.copyWith(
                            fontSize: getSize(16), fontWeight: FontWeight.w500),
                      ),
                      // SizedBox(
                      //   height: getSize(4),
                      // ),
                      // Text(
                      //   toUser?.userName ?? "",
                      //   style: appTheme.black14Normal.copyWith(
                      //       fontSize: getSize(16), fontWeight: FontWeight.w700),
                      // )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Get Sorted List By Chat dates...
  List<ChatObj> sortChatByDate(List<MessageObj> chatList) {
    List<ChatObj> tempArray = [];
    chatList.forEach((chats) {
      //Get list Index...
      int transIndex = tempArray.indexWhere((item) {
        return DateFormat('dd MMMM yyyy')
                .format(item.chatDate ?? DateTime.now()) ==
            DateFormat('dd MMMM yyyy').format(
                chats.chatDate ?? DateTime.now()); //Sort by List Category...
      });
      //Check If Project Already Added, if added then add category and list in same project...
      if (transIndex >= 0) {
        tempArray[transIndex].messageObjList?.insert(0, chats);
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
