import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Screens/OnboardingVerfication/VerificationProfile.dart';

class VerficationInvitation extends StatefulWidget {
  VerficationInvitation({Key? key}) : super(key: key);

  @override
  State<VerficationInvitation> createState() => _VerficationInvitationState();
}

class _VerficationInvitationState extends State<VerficationInvitation> {
  TextEditingController invitationController = TextEditingController();

  callApiForVerification() async {
    if (invitationController.text.length == 0) {
      View.showMessage(context, "Please enter Verificatiion code.");
      return;
    }

    Map<String, dynamic> req = {};
    req["verify_code"] = invitationController.text;

    NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.invitationVerification,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: req,
      method: MethodType.Post,
      successCallback: (response, message) async {
        NetworkClient.getInstance.hideProgressDialog();

        if (response != null) {
          if (response["verify_code"] == true) {
            NavigationUtilities.push(VerificationProfile());
          } else {
            View.showMessage(context, response["message"]);
          }
        }
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
      backgroundColor: ColorConstants.colorPrimary,
      appBar: getAppBar(context, "Verification",
          isWhite: true, leadingButton: getBackButton(context)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: getSize(16), bottom: getSize(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getCircle(true),
                  getTopLine(true),
                  getCircle(false),
                  getTopLine(false),
                  getCircle(false)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text("Invitation code",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: getFontSize(14),
                          color: ColorConstants.red,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: getSize(28),
                  ),
                  Text("Upload profile",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: getFontSize(14),
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: getSize(65),
                  ),
                  Text("Complete",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: getFontSize(14),
                          color: Colors.grey,
                          fontWeight: FontWeight.w600))
                ],
              ),
            ),
            Container(
              width: MathUtilities.screenWidth(context),
              height: getSize(210),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icInviteCode),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: getSize(16), top: getSize(40)),
                child: Text("Join us as\na host",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: getFontSize(24),
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getSize(16)),
              child: Text("Enter invitation code",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: getFontSize(16),
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: getSize(16)),
                  child: Container(
                    width: MathUtilities.screenWidth(context) / 1.8,
                    child: TextField(
                      controller: invitationController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(getSize(30))),
                          borderSide: BorderSide(
                            color: ColorConstants.red,
                            width: 1,
                          ),
                        ),
                        labelText: 'Enter invitation code',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      callApiForVerification();
                    },
                    child: Container(
                        height: getSize(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            getSize(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ColorConstants.gradiantStart,
                              ColorConstants.red
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text("VERIFY",
                              style: appTheme?.whiteBold32
                                  .copyWith(fontSize: getFontSize(18))),
                        )),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(getSize(16)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: fromHex("#FFACAC"),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Q",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getFontSize(16),
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("How to get an invitation code?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: getFontSize(16),
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: getSize(320),
                        child: Text(
                            "Get your invitation code from your agency or friend.",
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: getFontSize(12),
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCircle(bool isColor) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: isColor ? ColorConstants.red : Colors.grey),
    );
  }

  Widget getTopLine(bool isColor) {
    return Container(
      height: 1,
      width: (MathUtilities.screenWidth(context) / 2) - 60,
      color: isColor ? ColorConstants.red : Colors.grey,
    );
  }
}
