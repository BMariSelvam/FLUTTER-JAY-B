import 'package:flutter/material.dart';

class MyColors {
  static const Color mainTheme = Color.fromRGBO(71, 61, 192, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color greyText = Color.fromRGBO(154, 154, 154, 1);
  static const Color scaffold = Colors.white24;
  static const Color red = Colors.red;
  static const Color tpt = Colors.transparent;

  static const Color lightmainTheme2 = Color.fromRGBO(222, 219, 255, 1.0);
  static const Color green = Colors.green;
  static const Color greyBackground = Color.fromRGBO(248, 234, 250, 1);
  static const Color greyIcon = Color.fromRGBO(220, 220, 220, 1.0);
  static const Color lightmainTheme = Color.fromRGBO(179, 172, 255, 1.0);
  static const Color lightsubTheme = Color.fromRGBO(253, 0, 52, 1.0);
  static const Color pink = Color.fromRGBO(239, 21, 60, 1.0);

  static const Color drakgreyText = Color.fromRGBO(32, 32, 32, 1);
  static const Color lightgrey = Color.fromRGBO(32, 32, 32, 1);
  static const Color lightBluegrey = Color.fromRGBO(221, 220, 220, 1);

  static const Color visitedClr = Color.fromRGBO(193, 248, 164, 1.0);
  static const Color notVisitedClr = Color.fromRGBO(252, 159, 177, 1.0);

  static const MaterialColor primaryCustom = MaterialColor(0xFF473DC0, {
    50: Color.fromRGBO(24, 205, 237, 1.0),
    100: Color.fromRGBO(30, 186, 231, 1.0),
    200: Color.fromRGBO(37, 166, 225, 1.0),
    300: Color.fromRGBO(42, 150, 220, 1.0),
    400: Color.fromRGBO(49, 130, 214, 1.0),
    500: Color.fromRGBO(54, 113, 208, 1.0),
    600: Color.fromRGBO(57, 103, 205, 1.0),
    700: Color.fromRGBO(62, 87, 200, 1.0),
    800: Color.fromRGBO(66, 76, 197, 1.0),
    900: Color.fromRGBO(71, 61, 192, 1.0),
  });
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}
