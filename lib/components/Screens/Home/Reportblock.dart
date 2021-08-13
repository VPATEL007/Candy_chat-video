import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/utils/CommonTextfield.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class ReportBlock extends StatefulWidget {
  ReportBlock({Key key}) : super(key: key);

  @override
  _ReportBlockState createState() => _ReportBlockState();
}

class _ReportBlockState extends State<ReportBlock> {
  final TextEditingController _reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(
        context,
        "Report",
        isWhite: true,
        leadingButton: getBackButton(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: getSize(32), right: getSize(32)),
          child: Column(
            children: [
              Expanded(child: getScrollView()),
              getReportButton(),
              SizedBox(
                height: getSize(16),
              ),
              getPopBottomButton(context, "Report & Block", () {}),
            ],
          ),
        ),
      ),
    );
  }

  getReportButton() {
    return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.red, width: 1),
          borderRadius: BorderRadius.circular(
            getSize(16),
          ),
          color: fromHex("#FFDFDF"),
        ),
        child: Center(
          child: Text("Report",
              style: appTheme.black16Bold.copyWith(
                  color: ColorConstants.red, fontSize: getFontSize(18))),
        ));
  }

  getScrollView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          getProfileImage(),
          SizedBox(
            height: getSize(20),
          ),
          getRadioButton("Incorrect information", true),
          SizedBox(
            height: getSize(16),
          ),
          getRadioButton("Sexal contact", false),
          SizedBox(
            height: getSize(16),
          ),
          getRadioButton("Harassment or repulsive language", false),
          SizedBox(
            height: getSize(16),
          ),
          getRadioButton("Unreasonable demands", false),
          SizedBox(
            height: getSize(16),
          ),
          CommonTextfield(
            textOption: TextFieldOption(
                hintText: "Input report reason",
                maxLine: 5,
                inputController: _reasonController),
            textCallback: (text) {},
          ),
          SizedBox(
            height: getSize(16),
          ),
        ],
      ),
    );
  }

  getRadioButton(String text, bool isSelected) {
    return Container(
      width: MathUtilities.screenWidth(context),
      decoration: BoxDecoration(
        color: fromHex("#F6F6F6"),
        borderRadius: BorderRadius.circular(
          getSize(10),
        ),
      ),
      child: Padding(
          padding: EdgeInsets.all(getSize(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: appTheme.black14Normal
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Image.asset(
                isSelected ? radioSelected : radio,
                height: getSize(18),
                width: getSize(18),
              )
            ],
          )),
    );
  }

  Widget getProfileImage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: getSize(21)),
        child: Container(
          width: getSize(156),
          height: getSize(210),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 7,
                  spreadRadius: 5,
                  offset: Offset(0, 3)),
            ],
            borderRadius: BorderRadius.circular(
              getSize(20),
            ),
            image: DecorationImage(
              image: AssetImage(icTemp),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
