import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ButtonStyles {
  static ButtonStyle text1(BuildContext context) {
    final theme = Theme.of(context);

    return ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey[600]!;
        return Colors.white;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey;
        return theme.primaryColor.withOpacity(0.12);
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyles.button1Grey;
        }
        return TextStyles.button1;
      }),
    );
  }

  static ButtonStyle text1Google(BuildContext context) {
    final theme = Theme.of(context);

    return ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey[600]!;

        return Colors.white;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) return Colors.grey;
        return theme.primaryColor.withOpacity(0.12);
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyles.google1White30;
        }
        return TextStyles.google1;
      }),
    );
  }

  static ButtonStyle outlined1(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide(width: 2, color: theme.primaryColor),
    );
  }

  static ButtonStyle elevated(
    BuildContext context, {
    double radius = 24,
    double? width,
    double? height,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);

    return ButtonStyle(
      enableFeedback: true,
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(TextStyles.button1),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.any(kInteractiveMaterialState.contains)) {
          return Colors.white70;
        } else if (states.any(kDisabledMaterialState.contains)) {
          return Colors.grey;
        }

        return Colors.white;
      }),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.any(kInteractiveMaterialState.contains)) {
          return Color.alphaBlend(
            Colors.black12,
            backgroundColor ?? theme.primaryColor,
          );
        } else if (states.any(kDisabledMaterialState.contains)) {
          return Colors.grey[700]!;
        }

        return backgroundColor ?? theme.primaryColor;
      }),
    );
  }

  // static ButtonStyle elevated2(BuildContext context) {
  //   final theme = Theme.of(context);

  //   return ElevatedButton.styleFrom(
  //     primary: theme.primaryColor,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(4),
  //     ),
  //   );
  // }

  static ButtonStyle elevatedStadium(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      primary: theme.colorScheme.secondary,
      onPrimary: Colors.white,
      shape: const StadiumBorder(),
    );
  }

  static ButtonStyle elevatedStadiumGrey() {
    return ElevatedButton.styleFrom(
      primary: Colors.grey,
      shape: const StadiumBorder(),
    );
  }

  static ButtonStyle elevatedFullWidth(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      primary: theme.colorScheme.primary,
      minimumSize: const Size(double.maxFinite, 48),
      shape: const StadiumBorder(),
    );
  }
}
