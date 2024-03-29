import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConstants {
  static Color colorPrimary = fromHex("#FFFFFF");
  static Color lightPrimary = fromHex("#ADEFEF");
  static Color textGray = fromHex("#7B7E84");
  static Color borderColor = fromHex("#CCCCCC");
  static Color placeholderColor = fromHex("#7B7E84");
  static Color bgColor = fromHex("#FFFFFF");
  static Color introgrey = fromHex("#999999");
  static Color black = fromHex("#FFFFFF");
  static Color red = fromHex("#EAA11B");
  static Color button = fromHex("#FF013E");
  static Color facebook = fromHex("#1877F2");
  static Color gradiantStart = fromHex("#EAA11B");
  static Color redText = fromHex("#fcbd2b");
  static Color grayBackGround = fromHex("#303030");
  static Color mainBgColor = fromHex("#000000");
  static Color activeStatusColor = fromHex("#F55050");
  static Color inActiveStatusColor = fromHex("#50F5C3");
  static Color calenderGreyColor = fromHex("#ACACAC");
  static Color dropShadowColor = fromHex("#3A393A");
  static Color greyC4Color = fromHex("#C4C4C4");

  //Error border and Text color
  static Color errorColor = fromHex("#FF4B4B");

  static MaterialColor accentCustomColor =
  MaterialColor(0xFF2B0DB2, accentColor);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(255, 206, 15, .1),
  100: Color.fromRGBO(255, 206, 15, .2),
  200: Color.fromRGBO(255, 206, 15, .3),
  300: Color.fromRGBO(255, 206, 15, .4),
  400: Color.fromRGBO(255, 206, 15, .5),
  500: Color.fromRGBO(255, 206, 15, .6),
  600: Color.fromRGBO(255, 206, 15, .7),
  700: Color.fromRGBO(255, 206, 15, .8),
  800: Color.fromRGBO(255, 206, 15, .9),
  900: Color.fromRGBO(255, 206, 15, 1),
};

Map<int, Color> accentColor = {
  50: Color.fromRGBO(45, 13, 178, .1),
  100: Color.fromRGBO(45, 13, 178, .2),
  200: Color.fromRGBO(45, 13, 178, .3),
  300: Color.fromRGBO(45, 13, 178, .4),
  400: Color.fromRGBO(45, 13, 178, .5),
  500: Color.fromRGBO(45, 13, 178, .6),
  600: Color.fromRGBO(45, 13, 178, .7),
  700: Color.fromRGBO(45, 13, 178, .8),
  800: Color.fromRGBO(45, 13, 178, .9),
  900: Color.fromRGBO(45, 13, 178, 1),
};

MaterialColor colorCustom = MaterialColor(0xffffce0f, color);
