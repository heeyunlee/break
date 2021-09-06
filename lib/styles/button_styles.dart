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
        return TextStyles.button1Grey;
      }
      return TextStyles.button1;
    }),
  );

  static final text1Google = ButtonStyle(
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
        return TextStyles.google1White30;
      }
      return TextStyles.google1;
    }),
  );

  static final outlined1 = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: const BorderSide(width: 2, color: kPrimaryColor),
  );

  static final elevated1 = ElevatedButton.styleFrom(
    primary: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final elevatedFullWidth = ElevatedButton.styleFrom(
    primary: kPrimaryColor,
    minimumSize: const Size(double.maxFinite, 48),
    shape: const StadiumBorder(),
  );
}
