import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonTextfield.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class Chat extends StatefulWidget {
  bool isChat = false;
  Chat({Key key, this.isChat}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Helmi Lutvyandi",
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
            Padding(
              padding: EdgeInsets.all(getSize(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Image.asset(
                  loginBg,
                  width: getSize(36),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ]),
      bottomSheet: chatTextFiled(),
      body: widget.isChat == true ? chatList() : emptyChat(),
    );
  }

  Widget chatList() {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: getSize(20), bottom: getSize(120)),
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return index == 0
            ? Column(
                children: [
                  Container(
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
                        "Yesterday",
                        style: appTheme.black12Normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getSize(6),
                  )
                ],
              )
            : getChatItem(index);
      },
    );
  }

  Widget getChatItem(int index) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 0),
      child: Align(
        alignment: index % 2 == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: index % 2 == 0
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 0, maxWidth: getSize(260)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight:
                          Radius.circular(getSize(index % 2 == 0 ? 16 : 0)),
                      topLeft:
                          Radius.circular(getSize(index % 2 != 0 ? 16 : 0)),
                      bottomLeft: Radius.circular(getSize(16)),
                      bottomRight: Radius.circular(getSize(16))),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: index % 2 != 0
                        ? [ColorConstants.gradiantStart, ColorConstants.red]
                        : [fromHex("#F1F1F1"), fromHex("#F1F1F1")],
                  )),
              padding: EdgeInsets.all(16),
              child: Text(
                "Would be awesome!",
                style: appTheme.black12Normal.copyWith(
                    fontWeight: FontWeight.w500,
                    color: index % 2 != 0 ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(
              height: getSize(6),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                "12:28 Pm",
                textAlign: index % 2 == 0 ? TextAlign.left : TextAlign.right,
                style: appTheme.black12Normal
                    .copyWith(fontWeight: FontWeight.w500),
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
        widget.isChat == false
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
                          child: Text(
                            "Send",
                            style: appTheme.black14Normal.copyWith(
                                fontWeight: FontWeight.w700,
                                color: ColorConstants.red),
                          ),
                        ),
                        inputController: _chatController),
                    textCallback: (text) {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
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
}
