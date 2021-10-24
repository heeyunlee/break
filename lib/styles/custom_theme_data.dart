import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/styles/platform_colors.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

class CustomThemeData {
  static ThemeData createTheme(MaterialYouPalette? palette) {
    final background = palette?.neutral1.shade900;
    final primary = palette?.accent1.shade300;
    final secondary = palette?.accent3.shade300;

    return ThemeData(
      fontFamily: TextStyles.defaultFontFamily,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: palette?.accent1.shade200 ?? ThemeColors.primary300,
      primaryColor: primary ?? ThemeColors.primary500,
      primaryColorDark: palette?.accent1.shade500 ?? ThemeColors.primary700,
      scaffoldBackgroundColor: background ?? ThemeColors.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background ?? ThemeColors.background,
      ),
      backgroundColor: background ?? ThemeColors.background,
      primarySwatch: MaterialColor(
        primary?.value ?? ThemeColors.primary500.value,
        {
          50: palette?.accent1.shade50 ?? ThemeColors.primary50,
          100: palette?.accent1.shade100 ?? ThemeColors.primary100,
          200: palette?.accent1.shade200 ?? ThemeColors.primary200,
          300: palette?.accent1.shade300 ?? ThemeColors.primary300,
          400: palette?.accent1.shade400 ?? ThemeColors.primary400,
          500: palette?.accent1.shade500 ?? ThemeColors.primary500,
          600: palette?.accent1.shade600 ?? ThemeColors.primary600,
          700: palette?.accent1.shade700 ?? ThemeColors.primary700,
          800: palette?.accent1.shade800 ?? ThemeColors.primary800,
          900: palette?.accent1.shade900 ?? ThemeColors.primary900,
        },
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme(
          primary: primary ?? ThemeColors.primary500,
          onPrimary: Colors.white,
          primaryVariant: palette?.accent1.shade400 ?? ThemeColors.primary600,
          secondary: secondary ?? ThemeColors.secondary,
          onSecondary: Colors.white,
          secondaryVariant: palette?.accent3.shade400 ?? ThemeColors.secondary,
          background: Color.alphaBlend(
            primary?.withOpacity(0.08) ?? ThemeColors.card,
            background ?? ThemeColors.card,
          ),
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color.alphaBlend(
            primary?.withOpacity(0.08) ?? ThemeColors.card,
            background ?? ThemeColors.card,
          ),
          onSurface: Colors.white,
          brightness: Brightness.dark,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        background: background ?? ThemeColors.background,
        surface: palette?.accent1.shade700 ?? ThemeColors.card,
        onSurface: Colors.white,
        onBackground: Colors.white,
        primary: primary ?? ThemeColors.primary500,
        onPrimary: Colors.white,
        primaryVariant: palette?.accent1.shade400 ?? ThemeColors.primary600,
        secondary: secondary ?? ThemeColors.secondary,
        onSecondary: Colors.white,
        secondaryVariant: palette?.accent3.shade400 ?? ThemeColors.secondary,
        error: Colors.red,
        onError: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Color.alphaBlend(
          primary?.withOpacity(0.08) ?? ThemeColors.card,
          background ?? ThemeColors.card,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: background ?? ThemeColors.appBar,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
