import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/styles/platform_colors.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

class Themes {
  static ThemeData createTheme(MaterialYouPalette? palette) {
    final background = palette?.neutral1.shade900;
    final primary = palette?.accent1.shade300;
    final secondary = palette?.accent3.shade300;

    return ThemeData(
      fontFamily: TextStyles.defaultFontFamily,
      brightness: Brightness.dark,
      primaryColorLight: palette?.accent1.shade200 ?? ThemeColors.primary300,
      primaryColor: primary ?? ThemeColors.primary500,
      primaryColorDark: palette?.accent1.shade500 ?? ThemeColors.primary700,
      scaffoldBackgroundColor: background ?? ThemeColors.background,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background ?? ThemeColors.background,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme(
          primary: primary ?? ThemeColors.primary500,
          onPrimary: Colors.white,
          secondary: secondary ?? ThemeColors.secondary,
          onSecondary: Colors.white,
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
      cardTheme: _card,
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: background ?? ThemeColors.appBar,
      ),
      floatingActionButtonTheme: fab(primary),
      bottomSheetTheme: bottomSheet,
      dividerTheme: divider,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        background: background ?? ThemeColors.background,
        surface: palette?.accent1.shade700 ?? ThemeColors.card,
        onSurface: Colors.white,
        onBackground: Colors.white,
        primary: primary ?? ThemeColors.primary500,
        onPrimary: Colors.white,
        secondary: secondary ?? ThemeColors.secondary,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ).copyWith(
          primary: MaterialColor(
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
          background: background ?? ThemeColors.background),
    );
  }

  static const _card = CardTheme(
    clipBehavior: Clip.hardEdge,
    color: ThemeColors.grey900,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
    ),
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  );

  static FloatingActionButtonThemeData fab(Color? primaryColor) {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryColor ?? ThemeColors.primary500,
    );
  }

  static const bottomSheet = BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  );

  static const divider = DividerThemeData(
    color: Colors.transparent,
  );
}
