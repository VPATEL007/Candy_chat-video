import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';

import 'VerificationCamera.dart';

class VerificationFace extends StatefulWidget {
  VerificationFace({Key? key}) : super(key: key);

  @override
  State<VerificationFace> createState() => _VerificationFaceState();
}

class _VerificationFaceState extends State<VerificationFace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      appBar: getAppBar(context, "Face Verification",
          isWhite: true, leadingButton: getBackButton(context)),
      bottomSheet: getBottomButton(context, "Verify now", () {
        NavigationUtilities.push(VerificationCamera());
      }),
      body: Padding(
        padding: EdgeInsets.all(getSize(16)),
        child: Column(
          children: [
            SizedBox(height: getSize(16)),
            Text(
                "Let us know you are human. We want to keep platform safe for everyone",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: getFontSize(18),
                    color: Colors.black,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: getSize(32)),
            Text(
                "1. Keep the face and upper body clearly visiable.\n2. The profile photo and face validation photo sholud be same.\n3. Photos are confidantial and store securely.",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: getFontSize(14),
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: getSize(32)),
            Container(
              height: MathUtilities.screenWidth(context) - getSize(16),
              width: MathUtilities.screenWidth(context) - getSize(16),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(6)),
              child: Container(
                  child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      icVerification,
                      height: MathUtilities.screenWidth(context) - getSize(60),
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
