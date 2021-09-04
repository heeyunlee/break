import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/styles/text_styles.dart';

class TermsAndPrivacyPolicyWidget extends StatelessWidget {
  final SignInWithEmailModel model;

  const TermsAndPrivacyPolicyWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Intl.getCurrentLocale();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 8,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: S.current.acceptingTermsEmail,
          style: TextStyles.overlineGrey,
          children: <TextSpan>[
            TextSpan(
              text: S.current.terms,
              style: TextStyles.overlineGreyUnderlined,
              recognizer: TapGestureRecognizer()
                ..onTap = () => MainModel().launchTermsURL(context),
            ),
            TextSpan(
              text: S.current.and,
              style: TextStyles.overlineGrey,
            ),
            TextSpan(
              text: S.current.privacyPolicy,
              style: TextStyles.overlineGreyUnderlined,
              recognizer: TapGestureRecognizer()
                ..onTap = () => MainModel().launchPrivacyServiceURL(context),
            ),
            if (locale == 'ko')
              TextSpan(
                text: S.current.acepptingTermsKorean,
                style: TextStyles.overlineGrey,
              ),
          ],
        ),
      ),
    );
  }
}
