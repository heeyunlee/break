import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'constants.dart';

class ButtonStyles {
  static final text1 = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return kGrey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return kPrimaryColor.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return TextStyles.button1_grey;
      }
      return TextStyles.button1;
    }),
  );

  static final text1_bold = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return kGrey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return kPrimaryColor.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return TextStyles.button1_bold_grey;
      }
      return TextStyles.button1_bold;
    }),
  );

  static final text1_primary = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return kGrey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return kPrimaryColor.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return TextStyles.button1_bold_grey;
      }
      return TextStyles.button1_bold_primary;
    }),
  );

  static final text1_google = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return kGrey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return kPrimaryColor.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return TextStyles.google1_white30;
      }
      return TextStyles.google1;
    }),
  );

  static final outlined1 = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: BorderSide(width: 2, color: kPrimaryColor),
  );

  static final outlined_medium_size = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    side: BorderSide(width: 2, color: kPrimaryColor),
  );

  static final elevated1 = ElevatedButton.styleFrom(
    primary: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static final elevated_blue_accent = ElevatedButton.styleFrom(
    primary: Colors.blueAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
