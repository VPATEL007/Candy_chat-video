import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/components/Screens/Chat/Chat.dart';

class Visitor extends StatefulWidget {
  Visitor({Key key}) : super(key: key);

  @override
  _VisitorState createState() => _VisitorState();
}

class _VisitorState extends State<Visitor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context, "Visitor",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SafeArea(
        child: list(),
      ),
    );
  }

  Widget list() {
    return ListView.separated(
      padding: EdgeInsets.only(
          top: getSize(28), left: getSize(25), right: getSize(25)),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(onTap: () {}, child: visitorItem());
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: getSize(15),
        );
      },
    );
  }

  Widget visitorItem() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
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
              child: Image.asset(
                icTempProfile,
                height: getSize(48),
                width: getSize(51),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: getSize(11),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Calbert Warner",
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(getSize(12)),
                      child: Image.asset(
                        l2,
                        height: getSize(16),
                        width: getSize(16),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: getSize(6),
                    ),
                    Text(
                      "Australia",
                      style: appTheme.black14Normal
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              "2 Min ago",
              style: appTheme.black12Normal.copyWith(
                  color: fromHex("#C4C4C4"), fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
