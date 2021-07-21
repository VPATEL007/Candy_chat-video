import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/CommonWidgets.dart';

class OnBoarding extends StatefulWidget {
  static const route = "OnBoarding";
  OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = new PageController(initialPage: 0);
  PageController txtPageController = new PageController(initialPage: 0);
  int currentIndex = 0;

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
            getBarButtonText(context, currentIndex == 2 ? "" : "Skip", () {})
          ]),
      bottomSheet: getBottomButton(
          context, currentIndex == 2 ? "Get Started" : "Next", () {
        if (currentIndex == 2) {
        } else {
          currentIndex = currentIndex + 1;
          pageController.animateToPage(currentIndex,
              duration: Duration(milliseconds: 600),
              curve: Curves.linearToEaseOut);
          txtPageController.animateToPage(currentIndex,
              duration: Duration(milliseconds: 600),
              curve: Curves.linearToEaseOut);
        }
      }),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: getSize(340),
            child: PageView(
              controller: pageController,
              onPageChanged: (val) {
                currentIndex = val;
                txtPageController.animateToPage(currentIndex,
                    duration: Duration(milliseconds: 600),
                    curve: Curves.linearToEaseOut);
                referesh();
              },
              children: [
                getPageViewItem(intro1),
                getPageViewItem(intro2),
                getPageViewItem(intro3)
              ],
            ),
          ),
          SizedBox(
            height: getSize(45),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pageIndexIndicator(currentIndex == 0 ? true : false),
              pageIndexIndicator(currentIndex == 1 ? true : false),
              pageIndexIndicator(currentIndex == 2 ? true : false),
            ],
          ),
          SizedBox(
            height: getSize(30),
          ),
          Expanded(
            child: Container(
              child: PageView(
                controller: txtPageController,
                onPageChanged: (val) {
                  currentIndex = val;
                  pageController.animateToPage(currentIndex,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.linearToEaseOut);
                },
                children: [
                  getTextPageItem(
                      "Find",
                      ColorConstants.black,
                      "Your",
                      ColorConstants.black,
                      "Special",
                      ColorConstants.red,
                      "Someone",
                      ColorConstants.black,
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
                  getTextPageItem(
                      "More",
                      ColorConstants.black,
                      "Profiles",
                      ColorConstants.red,
                      "More",
                      ColorConstants.black,
                      "Dates",
                      ColorConstants.black,
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
                  getTextPageItem(
                      "Interact",
                      ColorConstants.black,
                      "Around",
                      ColorConstants.red,
                      "The",
                      ColorConstants.black,
                      "World",
                      ColorConstants.black,
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
                ],
              ),
            ),
          ),
          // Spacer(),
          // getBottomButton(currentIndex == 2 ? "Get Started" : "Next", () {
          //   if (currentIndex == 2) {
          //   } else {
          //     currentIndex = currentIndex + 1;
          //     pageController.animateToPage(currentIndex,
          //         duration: Duration(milliseconds: 600),
          //         curve: Curves.linearToEaseOut);
          //     txtPageController.animateToPage(currentIndex,
          //         duration: Duration(milliseconds: 600),
          //         curve: Curves.linearToEaseOut);
          //   }
          // }),
          // SizedBox(
          //   height: getSize(16),
          // ),
        ],
      ),
    );
  }

  getTextPageItem(String t1, Color c1, String t2, Color c2, String t3, Color c3,
      String t4, Color c4, String desc) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getText(t1, c1),
              SizedBox(
                width: getSize(8),
              ),
              getText(t2, c2)
            ],
          ),
          SizedBox(
            height: getSize(4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getText(t3, c3),
              SizedBox(
                width: getSize(8),
              ),
              getText(t4, c4)
            ],
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

  getPageViewItem(String image) {
    return Container(
      child: Image.asset(image),
    );
  }

  getText(String text, Color color) {
    return Text(text,
        style: TextStyle(
            fontSize: getFontSize(25),
            color: color,
            fontWeight: FontWeight.w800));
  }
}
