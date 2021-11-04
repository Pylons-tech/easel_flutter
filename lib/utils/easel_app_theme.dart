import 'package:flutter/material.dart';

class EaselAppTheme{
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kGrey = Color(0xFF8D8C8C);
  static const Color kLightGrey = Color(0xFFC4C4C4);
  static const Color kBlack = Colors.black;
  static const Color kBlue = Color(0xFF1212C4);
  static const Color kDarkText = Color(0xFF080830);
  static const Color kLightText = Color(0xFF464545);


  static ThemeData theme = ThemeData(
    backgroundColor: kWhite,
    primaryColor: kWhite,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: kWhite,
    visualDensity: VisualDensity.standard,
  );

}