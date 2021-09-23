import 'package:flutter/material.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/styles/text_styles.dart';

class ButtonStyles {
  static final text1 = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return ThemeColors.grey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return ThemeColors.primary500.withOpacity(0.12);
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
      if (states.contains(MaterialState.disabled)) return ThemeColors.grey600;

      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return ThemeColors.primary500.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return TextStyles.google1White30;
      }
      return TextStyles.google1;
    }),
  );

  static final text1SecondaryW900 = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return ThemeColors.grey600;

      // return kSecondaryColor;
      return ThemeColors.secondary;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      // return kSecondaryColor.withOpacity(0.12);
      return ThemeColors.secondary.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return TextStyles.button1Grey;
      }
      return TextStyles.button1SecondaryW900;
    }),
  );

  static final outlined1 = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: const BorderSide(width: 2, color: ThemeColors.primary500),
  );

  static final elevated1 = ElevatedButton.styleFrom(
    primary: ThemeColors.primary500,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final elevated2 = ElevatedButton.styleFrom(
    primary: ThemeColors.primary500,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  static final elevatedStadium = ElevatedButton.styleFrom(
    primary: ThemeColors.primary500,
    shape: const StadiumBorder(),
  );

  static final elevatedStadiumGrey = ElevatedButton.styleFrom(
    primary: Colors.grey,
    shape: const StadiumBorder(),
  );

  static final elevatedFullWidth = ElevatedButton.styleFrom(
    primary: ThemeColors.primary500,
    minimumSize: const Size(double.maxFinite, 48),
    shape: const StadiumBorder(),
  );
}
