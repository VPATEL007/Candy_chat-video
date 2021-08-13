import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import '../app.export.dart';
import '../theme/app_theme.dart';

getBottomButton(BuildContext context, String text, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding: EdgeInsets.fromLTRB(getSize(16), getSize(0), getSize(16),
          MathUtilities.safeAreaBottomHeight(context) + getSize(16)),
      child: Container(
          height: getSize(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              getSize(16),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorConstants.gradiantStart, ColorConstants.red],
            ),
          ),
          child: Center(
            child: Text(text,
                style:
                    appTheme.whiteBold32.copyWith(fontSize: getFontSize(18))),
          )),
    ),
  );
}

getPopBottomButton(BuildContext context, String text, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding:
          EdgeInsets.fromLTRB(getSize(0), getSize(0), getSize(0), getSize(16)),
      child: Container(
          height: getSize(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              getSize(16),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorConstants.gradiantStart, ColorConstants.red],
            ),
          ),
          child: Center(
            child: Text(text,
                style:
                    appTheme.whiteBold32.copyWith(fontSize: getFontSize(18))),
          )),
    ),
  );
}

getBackButton(BuildContext context, {bool isWhite = false}) {
  return Container(
    child: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Image.asset(
        back,
        color: isWhite == true ? Colors.white : Colors.black,
        width: getSize(18),
        height: getSize(18),
      ),
    ),
  );
}

getBarButton(
  BuildContext context,
  String imageName,
  VoidCallback onPressed, {
  bool isBlack = false,
  GlobalKey navigation_key,
}) {
  return IconButton(
    key: navigation_key,
    padding: EdgeInsets.all(3),
    onPressed: onPressed,
    icon: Image.asset(
      imageName,
      // color: isBlack == true ? Colors.black : Colors.white,
      width: getSize(22),
      height: getSize(22),
    ),
  );
}

getBarButtonText(
  BuildContext context,
  String title,
  VoidCallback onPressed,
) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding: EdgeInsets.only(
        top: getSize(15),
        right: getSize(20),
        bottom: getSize(10),
      ),
      child: Text(
        title,
        style: appTheme.black_Medium_16Text,
      ),
    ),
  );
}

getDrawerButton(BuildContext context, bool isBlack) {
  return IconButton(
    padding: EdgeInsets.all(3),
    onPressed: () {
      // RxBus.post(DrawerEvent(DrawerConstant.OPEN_DRAWER, false),
      //     tag: eventBusTag);
    },
    icon: Image.asset(
      "menu",
      color: isBlack == true ? Colors.black : Colors.white,
      width: getSize(26),
      height: getSize(26),
    ),
  );
}

getCommonIconWidget({
  String imageName,
  VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Align(
      alignment: Alignment.center,
      child: Image.asset(
        imageName,
        width: getSize(18),
        height: getSize(18),
      ),
    ),
  );
}

getClearDataButton(VoidCallback onClick) {
  return GestureDetector(
    onTap: onClick,
    child: Container(
      margin: EdgeInsets.only(
        right: getSize(17),
      ),
      child: Center(
        child: Padding(
            padding: EdgeInsets.all(
              getSize(2),
            ),
            child: Text(
              "Reset Filters",
              style: appTheme.black_Medium_16Text,
            )),
      ),
    ),
  );
}

getBarButtonWithColor(
    BuildContext context, String imageName, VoidCallback onPressed,
    {bool isBlack = false, String title = ""}) {
  return Padding(
      padding: EdgeInsets.only(
        top: getSize(15),
        right: getSize(20),
        bottom: getSize(10),
      ),
      child: Row(
        children: [
          Container(
            height: getSize(30),
            width: getSize(30),
            decoration: BoxDecoration(
              color: appTheme.colorPrimary,
              borderRadius: BorderRadius.all(Radius.circular(getSize(3))),
            ),
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: EdgeInsets.all(getSize(6)),
                child: Image.asset(
                  imageName,
                  height: getSize(18),
                  width: getSize(18),
                  color: isBlack ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          title.length > 0
              ? Text(
                  title,
                  style: appTheme.black_Medium_16Text,
                )
              : SizedBox()
        ],
      ));
}

getNavigationTheme(BuildContext context) {
  return TextTheme(
    title: TextStyle(
        color: AppTheme.of(context).buttonTextColor,
        fontFamily: "Gilroy",
        fontWeight: FontWeight.w700,
        fontSize: getSize(20)),
  );
}

fieldFocusChange(BuildContext context, FocusNode nextFocus) {
  FocusScope.of(context).requestFocus(nextFocus);
}

pushToWebview(BuildContext context, String text, String url) {
  var dataMap = Map<String, dynamic>();
  dataMap["url"] = url;
  dataMap["displayUrl"] = text;
  // NavigationUtilities.pushRoute(WebviewScreen.route,
  //     type: RouteType.fade, args: dataMap);
}

List<BoxShadow> getBoxShadow(BuildContext context) {
  return [
    BoxShadow(
      color: appTheme.colorPrimaryLight,
      offset: Offset(0, 3),
      blurRadius: 6,
    ),
  ];
}

Widget getPreferdSizeTitle(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size(0.0, getSize(70)),
    child: Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.all(getSize(16)),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: AppTheme.of(context).theme.textTheme.subhead.copyWith(
            fontWeight: FontWeight.w600, color: appTheme.colorPrimary),
      ),
    ),
  );
}

getCommonAuthToolBar(@required BuildContext context, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          margin: EdgeInsets.only(
            top: getSize(20),
            bottom: getSize(20),
          ),
          height: getSize(17),
          width: getSize(10),
          child: Image.asset(back)),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(
                bottom: getSize(20),
              ),
              height: getSize(50),
              width: getSize(42),
              child: Image.asset("")),
          Padding(
            padding: EdgeInsets.only(
              bottom: getSize(20),
            ),
            child: Text(
              text,
              style: appTheme.black_Heavy_24Text,
            ),
          ),
          Container(
              width: MathUtilities.screenWidth(context),
              child: Image.asset("")),
        ],
      ),
    ],
  );
}

Widget getPreferdSizeTitleForPayment(
    BuildContext context, String title, String titleAmount) {
  return PreferredSize(
    preferredSize: Size(0.0, getSize(80)),
    child: Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(
        getSize(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            // textAlign: TextAlign.left,
            style: AppTheme.of(context).theme.textTheme.subhead.copyWith(
                fontWeight: FontWeight.w600, color: appTheme.colorPrimary),
          ),
          Text(
            titleAmount,
            // textAlign: TextAlign.left,
            style: AppTheme.of(context).theme.textTheme.subhead.copyWith(
                fontWeight: FontWeight.w600, color: appTheme.colorPrimary),
          ),
        ],
      ),
    ),
  );
}

Widget getAppBar(BuildContext context, String title,
    {Widget leadingButton,
    Brightness brightness,
    List<Widget> actionItems,
    bool isWhite = false,
    bool isTitleShow = true,
    TextAlign textalign,
    PreferredSize widget,
    bool centerTitle}) {
  //Status//(darken(AppTheme.of(context).accentColor,0.2));

  return AppBar(
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: isWhite == true
          ? AppTheme.of(context).theme.textTheme.title.color
          : appTheme.whiteColor,
    ),
    centerTitle: centerTitle ?? true,
    elevation: 0,
    title: isTitleShow
        ? Text(
            title,
            style: appTheme.black16Bold.copyWith(fontSize: getFontSize(18)),
            textAlign: textalign ?? TextAlign.center,
          )
        : Container(),
    textTheme: getNavigationTheme(context),
    leading: leadingButton ??= null,
    automaticallyImplyLeading: leadingButton != null,
    backgroundColor: isWhite == true ? Colors.white : appTheme.colorPrimary,
    actions: actionItems == null ? null : actionItems,
    bottom: widget,
  );
}

addPrefixZero(int value) {
  return value < 10 ? '0' + value.toString() : value.toString();
}

getTitleText(
  BuildContext context,
  String text, {
  Color color,
  double fontSize,
  TextAlign alignment = TextAlign.left,
  FontWeight fontweight,
  Overflow overflow,
}) {
  return Text(
    text,
    style: AppTheme.of(context).theme.textTheme.display2.copyWith(
          color: color,
          fontFamily: 'CerebriSans',
          fontSize: fontSize == null ? getSize(16) : fontSize,
          fontWeight: fontweight == null ? FontWeight.w600 : fontweight,
        ),
    textAlign: alignment,
  );
}

getSubTitleText(
  BuildContext context,
  String text, {
  Color color,
  double fontSize,
  TextAlign alignment = TextAlign.left,
  FontWeight fontweight,
  Overflow overflow,
}) {
  return Text(
    text,
    style: AppTheme.of(context).theme.textTheme.display2.copyWith(
          color: color,
          fontSize: fontSize == null ? getSize(16) : fontSize,
          fontWeight: fontweight == null ? FontWeight.bold : fontweight,
        ),
    textAlign: alignment,
  );
}

Text getBodyText(BuildContext context, String text,
    {Color color,
    double fontSize,
    double letterSpacing,
    bool underline = false,
    alignment: TextAlign.center,
    FontWeight fontweight,
    TextOverflow textoverflow,
    int maxLines = 1}) {
  return Text(
    text,
    style: AppTheme.of(context).theme.textTheme.body2.copyWith(
        color: color,
        fontSize: fontSize == null ? getSize(14) : fontSize,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontWeight: fontweight == null ? FontWeight.normal : fontweight,
        letterSpacing: letterSpacing),
    overflow: textoverflow,
    maxLines: maxLines,
    //overflow: TextOverflow.fade,
    //maxLines: 1,
    textAlign: alignment,
  );
}

bool useWhiteForeground(Color backgroundColor) =>
    1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;

// changeStatusColor(Color color) async {
//   try {
//     await FlutterStatusbarcolor.setStatusBarColor(color, animate: false);
//     if (useWhiteForeground(color)) {
//       FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
//     } else {
//       FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
//     }
//   } on PlatformException catch (e) {
//     debugPrint(e.toString());
//   }
// }

// changeNavigationColor(Color color) async {
//   if (Platform.isAndroid) {
//     try {
//       await FlutterStatusbarcolor.setNavigationBarColor(color, animate: false);
//       if (useWhiteForeground(color)) {
//         FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
//       } else {
//         FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
//       }
//     } on PlatformException catch (e) {
//       debugPrint(e.toString());
//     }
//   }
// }

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar appBar;

  CustomAppBar({
    Key key,
    @required this.appBar,
  })  : preferredSize = Size.fromHeight(130),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.preferredSize.height,
      child: ClipPath(
        child: widget.appBar,
        clipper: AppBarCurveWidget(),
      ),
    );
  }
}

class AppBarCurveWidget extends CustomClipper<Path> {
  AppBarCurveWidget() : super();

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = Offset(0, size.height - 50);
    var firstEndPoint = Offset(50, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(60, size.height - 50);
    path.lineTo(size.width - 50, size.height - 50);

    var secondControlPoint = Offset(size.width - 10, size.height - 50);
    var secondEndPoint = Offset(size.width, size.height - 80);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) =>
      oldClipper is AppBarCurveWidget;
}

getColorText(String text, Color color, {double fontSize = 25}) {
  return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: getFontSize(fontSize),
          color: color,
          fontWeight: FontWeight.w800));
}

getCoinItem(bool isSelected, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(right: getSize(10), bottom: getSize(10)),
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: getSize(14)),
          child: Container(
            width: MathUtilities.screenWidth(context) / 2,
            decoration: BoxDecoration(
              color: isSelected ? fromHex("#FFDEDE") : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 7,
                    spreadRadius: 4,
                    offset: Offset(0, 3)),
              ],
              border: Border.all(
                  color: isSelected ? ColorConstants.red : Colors.white,
                  width: 1),
              borderRadius: BorderRadius.circular(
                getSize(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  icCoinPurchase,
                  height: getSize(36),
                  width: getSize(36),
                ),
                SizedBox(height: getSize(8)),
                Text(
                  "30 Coins",
                  style:
                      appTheme.black16Bold.copyWith(fontSize: getFontSize(18)),
                ),
                SizedBox(height: getSize(4)),
                Text(
                  "\$54.23",
                  style: appTheme.black14Normal
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: getSize(!isSelected ? 4 : 0)),
                !isSelected
                    ? Text(
                        "Save -38%",
                        style: appTheme.black16Bold.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.green),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
        isSelected
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: getSize(26), right: getSize(26)),
                  child: Container(
                    height: getSize(28),
                    decoration: BoxDecoration(
                      color: ColorConstants.red,
                      borderRadius: BorderRadius.circular(
                        getSize(14),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Save -38%",
                        style: appTheme.white14Bold
                            .copyWith(fontSize: getFontSize(12)),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    ),
  );
}
