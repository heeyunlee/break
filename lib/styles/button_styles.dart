import 'package:flutter/material.dart';
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

  static ButtonStyle elevated1(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      backgroundColor: theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static ButtonStyle elevated2(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      backgroundColor: theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  static ButtonStyle elevatedStadium(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: theme.colorScheme.secondary,
      shape: const StadiumBorder(),
    );
  }

  static ButtonStyle elevatedStadiumGrey() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      shape: const StadiumBorder(),
    );
  }

  static ButtonStyle elevatedFullWidth(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      minimumSize: const Size(double.maxFinite, 48),
      shape: const StadiumBorder(),
    );
  }
}
