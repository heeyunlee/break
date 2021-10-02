import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

class CustomThemeData {
  static final defaultTheme = ThemeData(
    fontFamily: TextStyles.defaultFontFamily,
    primaryColorBrightness: Brightness.dark,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: ThemeColors.background,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      centerTitle: true,
      color: ThemeColors.appBar,
    ),
    // highlightColor: ThemeColors.primary500.withOpacity(0.25),
    // splashColor: ThemeColors.primary500.withOpacity(0.5),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  );
}
