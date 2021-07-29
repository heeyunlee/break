import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/sign_in/sign_in_screen_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ShowSignInScreenButton extends StatelessWidget {
  const ShowSignInScreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(size.width - 32, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: BorderSide(width: 1.5, color: kPrimaryColor),
        ),
        onPressed: () => SignInScreenModel.show(context),
        child: Text(
          S.current.getStarted,
          style: TextStyles.button1,
        ),
      ),
    );
  }
}
