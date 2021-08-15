import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/sign_in_screen_model.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class ShowSignInScreenButton extends StatelessWidget {
  const ShowSignInScreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: OutlinedButton(
        style: ButtonStyles.elevated_full_width,
        onPressed: () => SignInScreenModel.show(context),
        child: Text(S.current.getStarted, style: TextStyles.button1),
      ),
    );
  }
}
