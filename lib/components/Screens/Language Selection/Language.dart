import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/app/utils/math_utils.dart';
import 'package:video_chat/app/utils/navigator.dart';
import 'package:video_chat/components/Screens/Onboarding/Onboarding.dart';

class LanguageSelection extends StatefulWidget {
  static const route = "LanguageSelection";
  bool isChange = false;

  LanguageSelection({Key key, this.isChange}) : super(key: key);

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String selctedLanguage = "english";

  @override
  void initState() {
    super.initState();
  }

  void referesh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorPrimary,
      bottomSheet: getBottomButton(context, "Next", () {
        NavigationUtilities.pushRoute(OnBoarding.route);
      }),
      body: SafeArea(
        child: Container(
          width: MathUtilities.screenWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isChange == null ? SizedBox() : getBackButton(context),
              SizedBox(
                height: getSize(widget.isChange == null ? 20 : 0),
              ),
              Center(
                child: getColorText(
                    widget.isChange == null ? "Select" : "Change",
                    ColorConstants.black,
                    fontSize: 35),
              ),
              SizedBox(
                height: getSize(6),
              ),
              Center(
                child:
                    getColorText("Language", ColorConstants.red, fontSize: 35),
              ),
              SizedBox(
                height: getSize(35),
              ),
              Center(
                child: Container(
                  width: getSize(200),
                  height: getSize(200),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 7,
                          spreadRadius: 5,
                          offset: Offset(0, 3)),
                    ],
                    border: Border.all(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.circular(
                      getSize(210),
                    ),
                    image: DecorationImage(
                        image: ExactAssetImage(l2), fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: getSize(69),
              ),
              Center(
                child:
                    getColorText("English", ColorConstants.black, fontSize: 35),
              ),
              SizedBox(
                height: getSize(30),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getLanguageItem("l1", l1, () {
                    selctedLanguage = "l1";
                    referesh();
                  }),
                  SizedBox(
                    width: getSize(20),
                  ),
                  getLanguageItem("english", l2, () {
                    selctedLanguage = "english";
                    referesh();
                  }),
                  SizedBox(
                    width: getSize(20),
                  ),
                  getLanguageItem("l3", l3, () {
                    selctedLanguage = "l3";
                    referesh();
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLanguageItem(String language, String image, Function click) {
    return InkWell(
      onTap: () {
        click();
      },
      child: Container(
        width: language == selctedLanguage ? getSize(100) : getSize(62),
        height: language == selctedLanguage ? getSize(100) : getSize(62),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(0, 3)),
          ],
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(
            getSize(62),
          ),
          image:
              DecorationImage(image: ExactAssetImage(image), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
