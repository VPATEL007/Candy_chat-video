import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';
import 'package:video_chat/components/Model/Auth/OnboardingModel.dart';
import 'package:video_chat/components/Screens/Auth/Login.dart';

class OnBoarding extends StatefulWidget {
  static const route = "OnBoarding";
  List<OnboardingModel> list;
  OnBoarding({Key key, this.list}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;

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
      appBar: getAppBar(context, "",
          isWhite: true,
          leadingButton: getBackButton(context),
          actionItems: [
            getBarButtonText(
                context, currentIndex == (widget.list.length - 1) ? "" : "Skip",
                () {
              NavigationUtilities.pushReplacementNamed(Login.route,
                  type: RouteType.fade);
            })
          ]),
      bottomSheet: getBottomButton(context,
          currentIndex == (widget.list.length - 1) ? "Get Started" : "Next",
          () {
        if (currentIndex == (widget.list.length - 1)) {
          NavigationUtilities.pushReplacementNamed(Login.route,
              type: RouteType.fade);
        } else {
          currentIndex = currentIndex + 1;
          pageController.animateToPage(currentIndex,
              duration: Duration(milliseconds: 600),
              curve: Curves.linearToEaseOut);
        }
      }),
      body: Stack(
        children: [
          Container(
            child: PageView(
              controller: pageController,
              onPageChanged: (val) {
                currentIndex = val;
                setState(() {});
              },
              children: [
                for (var item in widget.list) getPageViewItem(item),
              ],
            ),
          ),
          Positioned(
            top: getSize(420),
            left: (MathUtilities.screenWidth(context) / 2) -
                getSize(((widget.list.length / 2) * 21).toDouble()),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.list.length; i++)
                    pageIndexIndicator(currentIndex == i ? true : false),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getTextPageItem(String title, String desc) {
    var split = title.split(" ");
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: getSize(90), right: getSize(90)),
            child: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  for (var i = 0; i < split.length; i++)
                    new TextSpan(
                        text: split[i] + " ",
                        style: new TextStyle(
                            fontSize: getFontSize(25),
                            color: i % 2 == 0
                                ? Colors.black
                                : ColorConstants.redText,
                            fontWeight: FontWeight.w800)),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: getFontSize(25),
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: getSize(17),
          ),
          Padding(
            padding: EdgeInsets.only(left: getSize(16), right: getSize(16)),
            child: Text(desc,
                textAlign: TextAlign.center, style: appTheme.black12Normal),
          )
        ],
      ),
    );
  }

  Widget pageIndexIndicator(bool isCuurent) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(horizontal: 3),
      height: getSize(10),
      width: isCuurent ? getSize(20) : getSize(15),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2, color: Colors.white, style: BorderStyle.solid),
          color: isCuurent ? ColorConstants.red : Colors.grey[400],
          borderRadius: BorderRadius.circular(12)),
    );
  }

  getPageViewItem(OnboardingModel model) {
    return Container(
      child: Column(
        children: [
          getImageView(model.imageUrl,
              height: getSize(360),
              width: MathUtilities.screenWidth(context) - getSize(120)),
          Spacer(),
          getTextPageItem(model.title, model.introText),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }
}
