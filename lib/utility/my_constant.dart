import 'package:flutter/material.dart';

class MyConstant {
  

  static String appName = 'Ung Check Package';

  // for Route
  static String routePhotoService = '/photoService';

  // for Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String icon = 'images/icon.png';
  static String domainImage = 'http://210.86.171.110:89/shopeepic/';

  // for Color
  static Color primary = Color(0xff7807a5);
  static Color dark = Color(0xff450075);
  static Color light = Color(0xffab46d7);

  // for Style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: dark,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: dark,
      );

  TextStyle h2BlueStyle() => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.blue.shade900,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: dark,
      );

  TextStyle h3PrimaryStyle() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primary,
      );

  TextStyle h3normalStyle() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: dark,
      );
}
