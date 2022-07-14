import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_chat/app/Helper/Themehelper.dart';
import 'package:video_chat/app/constant/ColorConstant.dart';
import 'package:video_chat/app/utils/math_utils.dart';

class CommanButton extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  const CommanButton({Key? key, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getSize(52),
      alignment: Alignment.center,
      width: MathUtilities.screenWidth(context),
      margin: margin ?? EdgeInsets.symmetric(horizontal: getSize(35)),
      decoration: BoxDecoration(
          color: ColorConstants.red,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 18),
                blurRadius: 32,
                spreadRadius: -8,
                color: ColorConstants.dropShadowColor.withOpacity(0.14))
          ]),
      child: Text(
        'Ask my manager for help here',
        style: appTheme!.black16Bold.copyWith(
            color: ColorConstants.colorPrimary,
            fontWeight: FontWeight.w700,
            fontSize: getFontSize(16)),
      ),
    );
  }
}
