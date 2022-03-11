import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class Gender extends StatefulWidget {
  static const route = "Gender";
  final bool isFromPreGender;
  Gender({Key? key, this.isFromPreGender = false}) : super(key: key);

  @override
  _GenderState createState() => _GenderState();
}

enum Genders { Male, Female, None }

class _GenderState extends State<Gender> {
  Genders _genders = Genders.Male;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromPreGender) {
      _genders = Genders.Female;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(
        context,
        widget.isFromPreGender
            ? "Select Preferred Gender"
            : "Select Your Gender",
        leadingButton: widget.isFromPreGender ? getBackButton(context) : null,
        isWhite: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: getSize(35), right: getSize(35)),
          child: Container(
            width: MathUtilities.screenWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: getSize(70),
                ),
                InkWell(
                  onTap: () {
                    if (mounted)
                      setState(() {
                        _genders = Genders.Male;
                      });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        icMale,
                        height: getSize(140),
                      ),
                      _genders == Genders.Male
                          ? Image.asset(
                              radioSelected,
                              height: getSize(22),
                            )
                          : Image.asset(
                              radio,
                              height: getSize(22),
                            ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (mounted)
                      setState(() {
                        _genders = Genders.Female;
                      });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        icFemale,
                        height: getSize(140),
                      ),
                      _genders == Genders.Female
                          ? Image.asset(
                              radioSelected,
                              height: getSize(22),
                            )
                          : Image.asset(
                              radio,
                              height: getSize(22),
                            ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getColorText("Which", Colors.black),
                    SizedBox(
                      width: getSize(6),
                    ),
                    getColorText("Gender?", ColorConstants.redText)
                  ],
                ),
                SizedBox(
                  height: getSize(6),
                ),
                Text(
                  widget.isFromPreGender
                      ? "Select preferred opposite gender"
                      : "Choose your gender",
                  style: appTheme?.black14Normal,
                ),
                Spacer(),
                getPopBottomButton(context, "Next", () async {
                  callApiGender();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  callApiGender() async {
    // if (widget.isFromPreGender == false) {
    //   NetworkClient.getInstance.showLoader(context);
    //   await NetworkClient.getInstance.callApi(
    //     context: context,
    //     baseUrl: ApiConstants.apiUrl,
    //     command: ApiConstants.selectGender,
    //     headers: NetworkClient.getInstance.getAuthHeaders(),
    //     method: MethodType.Post,
    //     params: {
    //       "gender": describeEnum(_genders).toLowerCase(),
    //     },
    //     successCallback: (response, message) {
    //       NetworkClient.getInstance.hideProgressDialog();
    //       View.showMessage(context, message);
    //       Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => Gender(
    //           isFromPreGender: true,
    //         ),
    //       ));
    //     },
    //     failureCallback: (code, message) {
    //       NetworkClient.getInstance.hideProgressDialog();
    //       View.showMessage(context, message);
    //     },
    //   );
    // } else {
    //   NetworkClient.getInstance.showLoader(context);
    //   await NetworkClient.getInstance.callApi(
    //     context: context,
    //     baseUrl: ApiConstants.apiUrl,
    //     command: ApiConstants.selectGender,
    //     headers: NetworkClient.getInstance.getAuthHeaders(),
    //     method: MethodType.Post,
    //     params: {"prefgender": "female"},
    //     successCallback: (response, message) {
    //       NetworkClient.getInstance.hideProgressDialog();
    //       moveToScreen();
    //     },
    //     failureCallback: (code, message) {
    //       NetworkClient.getInstance.hideProgressDialog();
    //       View.showMessage(context, message);
    //     },
    //   );
    // }

//Gender
    NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.selectGender,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {
        "gender": describeEnum(_genders).toLowerCase(),
      },
      successCallback: (response, message) {},
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );

    //Preferred Gender
    // NetworkClient.getInstance.showLoader(context);
    await NetworkClient.getInstance.callApi(
      context: context,
      baseUrl: ApiConstants.apiUrl,
      command: ApiConstants.selectGender,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      method: MethodType.Post,
      params: {"prefgender": "female"},
      successCallback: (response, message) {
        NetworkClient.getInstance.hideProgressDialog();
        moveToScreen();
      },
      failureCallback: (code, message) {
        NetworkClient.getInstance.hideProgressDialog();
        View.showMessage(context, message);
      },
    );
  }

  moveToScreen() async {
    AppNavigation.shared.moveToHome();
    // NetworkClient.getInstance.showLoader(context);
    // var provider = Provider.of<FollowesProvider>(context, listen: false);
    // await provider.fetchMyProfile(context);
    // NetworkClient.getInstance.hideProgressDialog();

    // if (provider?.userModel?.userName == null ||
    //     provider.userModel.userName.isEmpty ||
    //     provider.userModel.userImages != null ||
    //     provider.userModel.userImages.isEmpty) {
    //   NavigationUtilities.pushReplacementNamed(EditProfileScreen.route,
    //       type: RouteType.fade);
    // } else {
    //   AppNavigation.shared.moveToHome();
    // }
  }
}
