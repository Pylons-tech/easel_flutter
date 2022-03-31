import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EaselAppTheme {
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kGrey = Color(0xFF8D8C8C);
  static const Color kLightGrey = Color(0xFFC4C4C4);
  static const Color kLightGrey02 = Color(0xFFF2EFEA);
  static const Color kDartGrey = Color(0xFF333333);
  static const Color kBlack = Colors.black;
  static const Color kBlue = Color(0xFF1212C4);
  static const Color kDarkText = Color(0xFF080830);
  static const Color kLightText = Color(0xFF464545);
  static const Color kRed = Color(0xFFFC4403);
  static const Color kWhite02 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color kWhite03 = Color(0xFFFBFBFB);
  static const Color kPurple01 = Color.fromRGBO(18, 18, 196, 0.6);
  static const Color kPurple02 = Color(0xFF4534CE);
  static const Color kDarkGreen = Color(0xFF3A8977);
  static const Color kYellow = Color(0xFFFFD83D);
  static const Color kLightRed = Color(0xFFEF4421);

  static ThemeData theme(BuildContext context) => ThemeData(
        backgroundColor: kWhite,
        primaryColor: kWhite,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kWhite,
        visualDensity: VisualDensity.standard,
      );

  static Color cardBackground = const Color(0xFFC4C4C4).withOpacity(0.2);
  static Color cardBackgroundSelected = const Color(0x801212C4).withOpacity(0.2);
}
