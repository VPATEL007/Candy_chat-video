import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';

import 'VerificationCamera.dart';

class VerificationFace extends StatefulWidget {
  static const route = "VerificationFace";
  VerificationFace({Key? key}) : super(key: key);

  @override
  State<VerificationFace> createState() => _VerificationFaceState();
}

class _VerificationFaceState extends State<VerificationFace> {
  XFile? imageFile;

  uploadImage() async {
    NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.uploadImages(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: "app-home-screen/upload-image",
      headers: NetworkClient.getInstance.getAuthHeaders(),
      image: imageFile!.path,
      successCallback: (response, message) {
        if (response != null) {
          verifyProfile(response.toString());
        }
      },
      failureCallback: (code, message) {
        View.showMessage(context, message);
      },
    );
  }

  verifyProfile(String url) async {
    Map<String, dynamic> req = {};
    req["user_id"] = app.resolve<PrefUtils>().getUserDetails()?.id;
    req["photo_url"] = url;

    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.verifyFace,
      method: MethodType.Post,
      params: req,
      successCallback: (response, message) async {
        AppNavigation.shared.goNextFromSplash();
        NetworkClient.getInstance.hideProgressDialog();
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.mainBgColor,
      appBar: getAppBar(context, "Face Verification",
          isWhite: false, leadingButton: getBackButton(context)),
      bottomSheet: getBottomButton(context, "Verify now", () {
        if (imageFile != null) {
          uploadImage();
        } else {
          NavigationUtilities.push(VerificationCamera(
            imageCapture: (image) {
              setState(() {
                imageFile = image;
              });
            },
          ));
        }
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
                    color: Colors.white,
                    fontWeight: FontWeight.w800)),
            SizedBox(height: getSize(32)),
            Text(
                "1. Keep the face and upper body clearly visiable.\n2. The profile photo and face validation photo sholud be same.\n3. Photos are confidantial and store securely.",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: getFontSize(14),
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: getSize(32)),
            Container(
              height: MathUtilities.screenWidth(context) - getSize(100),
              width: MathUtilities.screenWidth(context) - getSize(16),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(6)),
              child: Container(
                  child: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: imageFile == null
                          ? Container()
                          : Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.cover,
                              height: MathUtilities.screenWidth(context) -
                                  getSize(20),
                              width: MathUtilities.screenWidth(context) -
                                  getSize(20),
                            )),
                  imageFile == null
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            icVerification,
                            height: MathUtilities.screenWidth(context) -
                                getSize(60),
                          ),
                        )
                      : SizedBox(),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
