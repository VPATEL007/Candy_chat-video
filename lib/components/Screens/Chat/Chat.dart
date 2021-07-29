import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonTextfield.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Start your conversation with",
            style: appTheme.black14Normal.copyWith(
                fontWeight: FontWeight.w700, fontSize: getFontSize(18)),
          ),
          SizedBox(
            height: getSize(14),
          ),
          Text(
            "a simple wave, maybe?",
            style: appTheme.black14Normal.copyWith(
                fontWeight: FontWeight.w500, fontSize: getFontSize(18)),
          ),
          SizedBox(
            height: getSize(26),
          ),
          emptyChat(),
        ],
      ),
    );
  }

  Widget chatTextFiled() {
    return Container(
      color: fromHex("#F7F7F7"),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: getSize(26), left: getSize(20)),
              child: CommonTextfield(
                textOption: TextFieldOption(
                    radious: getSize(26),
                    hintText: "Type something....",
                    maxLine: 1,
                    fillColor: fromHex("#F1F1F1"),
                    postfixWid: Padding(
                      padding:
                          EdgeInsets.only(top: getSize(16), right: getSize(16)),
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
            child: Image.asset(icGift),
          ),
        ],
      ),
    );
  }

//Empty Chat
  Widget emptyChat() {
    return Stack(
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
              Image.asset(icWavingHand),
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
    );
  }
}
