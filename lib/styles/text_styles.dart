import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_player/styles/constants.dart';

/// My Custom TextStyle Convention
///
///
class TextStyles {
  static const defaultFontFamily = 'NanumSquareRound';
  static const menlo = 'menlo';

  static const headline1 = TextStyle(
    fontSize: 96,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: -1.5,
    fontFamily: defaultFontFamily,
  );

  static const headline2 = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: -0.5,
    fontFamily: defaultFontFamily,
  );

  static const headline3 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline3_menlo = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const headline4_bold = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const headline4_w900 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const headline4_menlo_w900_primary = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0.25,
    fontFamily: menlo,
  );

  static const headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5_bold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5_w900 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5_w900_primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5_menlo = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline5_menlo_primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: kPrimaryColor,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline5_menlo_bold_primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline5_menlo_w900_primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline5_menlo_bold_secondary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: kSecondaryColor,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline6 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6_bold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6_w900 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6_grey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6_grey_w900 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.grey,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6_menlo = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: menlo,
  );

  static const headline6_menlo_bold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: menlo,
  );

  /// Subtitle 1 Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 16,
  /// `letterSpacing` = 0.15
  static const subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_light = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_w900 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_w900_primary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_w900_secondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: kSecondaryColor,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_w900_greenAccent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.greenAccent,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_w900_lightGreenAccent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.lightGreenAccent,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_light_grey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_grey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1_menlo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: menlo,
  );

  static const subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  static const subtitle2_grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  static const subtitle2_menlo = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.1,
    fontFamily: menlo,
  );

  static const subtitle2_bold_grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  static const subtitle2_w900 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  /// Body 1 Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 16,
  /// `letterSpacing` = 0.50
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1_heighted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.5,
    height: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const body1_grey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1_black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1_menlo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: menlo,
  );

  static const body1_menlo_black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const body1_menlo_white54 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white54,
    letterSpacing: 0,
    fontFamily: menlo,
    height: 1.5,
  );

  static const body1_bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1_w800 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1_w900_menlo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  /// Body 2 Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 14,
  /// `letterSpacing` = 0.25
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_light = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_light_grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_w900 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_black = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_grey_bold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_grey700 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: kGrey700,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2_red = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.red,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  /// Button 1 Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 14,
  /// `letterSpacing` = 1.25
  static const button1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1_grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1_black = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1_bold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1_bold_grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1_bold_primary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  /// Button 2 Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 10,
  /// `letterSpacing` = 1.5
  static const button2 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
  );

  /// Caption Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 12,
  /// `letterSpacing` = 0.4
  static const caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.4,
    fontFamily: defaultFontFamily,
  );

  static const caption1_grey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.4,
    fontFamily: defaultFontFamily,
  );

  static const caption1_primary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: kPrimaryColor,
    letterSpacing: 0.4,
    fontFamily: defaultFontFamily,
  );

  static const caption1_black = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.4,
    fontFamily: defaultFontFamily,
  );

  /// Overline Text Styles
  ///
  /// Basic Settings
  /// `fontSize` = 10,
  /// `letterSpacing` = 1.5
  static const overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const overline_grey = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const overline_primary = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: kPrimaryColor,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const overline_gery_underlined = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
    decoration: TextDecoration.underline,
  );

  static const google1 = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  static const google1_white30 = TextStyle(
    fontSize: 15,
    color: Colors.white30,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );

  static final blackHans1 = GoogleFonts.blackHanSans(
    color: Colors.white,
    fontSize: 24,
  );
}
