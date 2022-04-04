import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Profile/edit_profile.dart';
import 'package:video_chat/provider/followes_provider.dart';

import 'VerificationFace.dart';

class VerificationProfile extends StatefulWidget {
  static const route = "VerificationProfile";
  VerificationProfile({Key? key}) : super(key: key);

  @override
  State<VerificationProfile> createState() => _VerificationProfileState();
}

class _VerificationProfileState extends State<VerificationProfile> {
  TextEditingController nickNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  DateTime _selectedDate = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  UserModel? _userInfo;

  @override
  void initState() {
    super.initState();
    getUserinfo();
  }

  getUserinfo() async {
    await Provider.of<FollowesProvider>(context, listen: false)
        .fetchMyProfile(context);
    _userInfo = Provider.of<FollowesProvider>(context, listen: false)
        .userModel!
        .toCloneInfo;

    if (mounted) setState(() {});

    nickNameController.text = _userInfo?.userName ?? "";
    _dobController.text = _userInfo?.dob ?? "";
    setState(() {});
  }

  bool isValid() {
    if (nickNameController.text.isEmpty) {
      View.showMessage(context, "Please enter Nickname.");
      return false;
    }

    if (_dobController.text.isEmpty) {
      View.showMessage(context, "Please select Date of Birth.");
      return false;
    }
    return true;
  }

  callApiForUpdateProfile() async {
    if (isValid()) {
      _userInfo?.userName = nickNameController.text;
      _userInfo?.dob = _dobController.text;

      await Provider.of<FollowesProvider>(context, listen: false)
          .saveMyProfile(context, _userInfo, []);

      NavigationUtilities.push(VerificationFace());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      appBar: getAppBar(context, "Upload profile",
          isWhite: true, leadingButton: getBackButton(context)),
      bottomSheet: getBottomButton(context, "Next", () {
        callApiForUpdateProfile();
      }),
      body: Column(
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
                getCircle(true),
                getTopLine(true),
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
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(height: getSize(60)),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                border: Border.all(
                    width: 2, color: Colors.grey, style: BorderStyle.solid),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  icPlaceWoman,
                  fit: BoxFit.contain,
                  height: 150,
                  width: 150,
                ),
              ),
            ),
          ),
          SizedBox(
            height: getSize(24),
          ),
          Padding(
            padding: EdgeInsets.only(left: getSize(16)),
            child: Text("Nickname",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: getFontSize(14),
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: EdgeInsets.all(getSize(16)),
            child: CommonTextfield(
              textOption: TextFieldOption(
                  hintText: "Enter Nickname",
                  inputController: nickNameController),
              textCallback: (text) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: getSize(16)),
            child: Text("Birthday",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: getFontSize(14),
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: EdgeInsets.all(getSize(16)),
            child: CommonTextfield(
              focusNode: AlwaysDisabledFocusNode(),
              textOption: TextFieldOption(
                postfixWid: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    "assets/Profile/calendar.png",
                    height: 10,
                    width: 10,
                  ),
                ),
                hintText: "Date of Birth",
                inputController: _dobController,
              ),
              tapCallback: () {
                _selectDate(context);
              },
              textCallback: (String text) {},
            ),
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final currentDat = DateTime.now();
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null
            ? _selectedDate
            : DateTime(currentDat.year - 18, currentDat.month, currentDat.day),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext? context, Widget? child) {
          return child ?? Container();
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dobController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dobController.text.length,
            affinity: TextAffinity.upstream));
    }
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
