import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

// TODO: FINISH PASSWROD STRENGTH METER

class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            _passwordStrengthMeter(context, ThemeColors.primary500),
            _passwordStrengthMeter(context, Colors.grey),
            _passwordStrengthMeter(context, Colors.grey),
            _passwordStrengthMeter(context, Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Weak', style: TextStyles.body1),
      ],
    );
  }

  Widget _passwordStrengthMeter(BuildContext context, Color color) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 2,
      ),
      child: Container(
        height: 4,
        width: (size.width - 48) / 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
