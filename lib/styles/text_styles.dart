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

  static const headline4 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const headline4Bold = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const headline4W900 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const headline5 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5Bold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5W900 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5W900Primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0,
    fontFamily: defaultFontFamily,
  );

  static const headline5MenloW900Primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const headline5MenloBoldSecondary = TextStyle(
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

  static const headline6Bold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6W900 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const headline6Grey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
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

  static const subtitle1Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1W900 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1W900Primary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: kPrimaryColor,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1W900Secondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: kSecondaryColor,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1Grey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.15,
    fontFamily: defaultFontFamily,
  );

  static const subtitle1Menlo = TextStyle(
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

  static const subtitle2Grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  static const subtitle2BoldGrey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  static const subtitle2BoldWhite38 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white38,
    letterSpacing: 0.1,
    fontFamily: defaultFontFamily,
  );

  static const subtitle2W900 = TextStyle(
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

  static const body1Heighted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.5,
    height: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const body1Grey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1Black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1Menlo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: menlo,
  );

  static const body1MenloBlack = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    letterSpacing: 0,
    fontFamily: menlo,
  );

  static const body1Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1W800 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: defaultFontFamily,
  );

  static const body1W900Menlo = TextStyle(
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

  static const body2Bold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2Grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2Light = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2LightGrey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.grey,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2W900 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2Black = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2GreyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2Grey700 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: kGrey700,
    letterSpacing: 0.25,
    fontFamily: defaultFontFamily,
  );

  static const body2Red = TextStyle(
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

  static const button1SecondaryW900 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    color: kSecondaryColor,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1Grey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: 1.25,
    fontFamily: defaultFontFamily,
  );

  static const button1Bold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
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

  static const caption1Grey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
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

  static const overlineGrey = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const overlinePrimary = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: kPrimaryColor,
    letterSpacing: 1.5,
    fontFamily: defaultFontFamily,
  );

  static const overlineGreyUnderlined = TextStyle(
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

  static const google1White30 = TextStyle(
    fontSize: 15,
    color: Colors.white30,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );

  static final blackHans1 = GoogleFonts.blackHanSans(
    color: Colors.white,
    fontSize: 28,
  );

  static final blackHans1Grey = GoogleFonts.blackHanSans(
    color: Colors.grey,
    fontSize: 28,
  );

  static final blackHans2 = GoogleFonts.blackHanSans(
    color: Colors.white,
    fontSize: 24,
  );

  static final blackHans3 = GoogleFonts.blackHanSans(
    color: Colors.white,
    fontSize: 20,
  );
}
