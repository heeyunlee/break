import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';

class TextStyles {
  static final kBodyText1w800 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.50,
    fontFamily: 'NanumSquareRound',
  );

  static final kBodyText2 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: 'NanumSquareRound',
  );

  static final kBodyText2_grey700 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: kGrey700,
    letterSpacing: 0.25,
    fontFamily: 'NanumSquareRound',
  );

  static final kBodyText2Red = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.red,
    letterSpacing: 0.25,
    fontFamily: 'NanumSquareRound',
  );
}
