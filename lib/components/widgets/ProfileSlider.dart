import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/constant/ImageConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class ProfileSlider extends StatefulWidget {
  Function(int) scroll;
  ProfileSlider({Key key, this.scroll}) : super(key: key);

  @override
  _ProfileSliderState createState() => _ProfileSliderState();
}

class _ProfileSliderState extends State<ProfileSlider> {
  PageController pageController = new PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getSize(300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(getSize(15)),
        child: PageView(
          scrollDirection: Axis.vertical,
          controller: pageController,
          children: [
            getPageViewItem(icTempProfile),
            getPageViewItem(loginBg),
            getPageViewItem(icTempProfile)
          ],
          onPageChanged: (val) {
            currentIndex = val;
            pageController.animateToPage(currentIndex,
                duration: Duration(milliseconds: 600),
                curve: Curves.linearToEaseOut);
            widget.scroll(currentIndex);
          },
        ),
      ),
    );
  }

  getPageViewItem(String image) {
    return Image.asset(
      image,
      width: MathUtilities.screenWidth(context),
      height: getSize(300),
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.4),
      colorBlendMode: BlendMode.overlay,
    );
  }
}

Widget pageIndexIndicator(bool isCuurent) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 400),
    margin: EdgeInsets.symmetric(vertical: 3),
    height: getSize(10),
    width: getSize(10),
    decoration: BoxDecoration(
        border: Border.all(
            width: isCuurent ? 0 : 2,
            color: Colors.white,
            style: BorderStyle.solid),
        color: isCuurent ? ColorConstants.red : Colors.white.withOpacity(0),
        borderRadius: BorderRadius.circular(12)),
  );
}
