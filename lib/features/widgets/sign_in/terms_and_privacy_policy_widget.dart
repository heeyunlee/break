import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/features/widgets/dialogs/show_exception_alert_dialog.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/styles/text_styles.dart';

class TermsAndPrivacyPolicyWidget extends StatefulWidget {
  final SignInWithEmailModel model;

  const TermsAndPrivacyPolicyWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<TermsAndPrivacyPolicyWidget> createState() =>
      _TermsAndPrivacyPolicyWidgetState();
}

class _TermsAndPrivacyPolicyWidgetState
    extends State<TermsAndPrivacyPolicyWidget> {
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
                ..onTap = () async {
                  final canLaunchs = await canLaunch(termsUrl);

                  if (canLaunchs) {
                    await launch(termsUrl);
                  } else {
                    if (!mounted) return;

                    await showExceptionAlertDialog(
                      context,
                      title: S.current.operationFailed,
                      exception: S.current.couldNotLaunch(termsUrl),
                    );
                  }
                },
              // ..onTap = () => MainModel().launchTermsURL(context),
            ),
            TextSpan(
              text: S.current.and,
              style: TextStyles.overlineGrey,
            ),
            TextSpan(
              text: S.current.privacyPolicy,
              style: TextStyles.overlineGreyUnderlined,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final canLaunchs = await canLaunch(privacyPolicyUrl);

                  if (canLaunchs) {
                    await launch(privacyPolicyUrl);
                  } else {
                    if (!mounted) return;

                    await showExceptionAlertDialog(
                      context,
                      title: S.current.operationFailed,
                      exception: S.current.couldNotLaunch(privacyPolicyUrl),
                    );
                  }
                },
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
