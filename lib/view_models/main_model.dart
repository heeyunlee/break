import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

class MainModel with ChangeNotifier {
  Future<void> launchTermsURL(BuildContext context) async {
    final bool canLaunchs = await canLaunchUrl(_termsUrl);

    if (canLaunchs) {
      await launchUrl(_termsUrl);
    } else {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: S.current.couldNotLaunch(_termsUrl),
      );
    }
  }

  Future<void> launchPrivacyServiceURL(BuildContext context) async {
    final bool canLaunchs = await canLaunchUrl(_privacyPolicyUrl);

    if (canLaunchs) {
      await launchUrl(_privacyPolicyUrl);
    } else {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: S.current.couldNotLaunch(_privacyPolicyUrl),
      );
    }
  }

  static final Uri _termsUrl = Uri.https(
    'app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750',
  );
  static final Uri _privacyPolicyUrl = Uri.https(
    'app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1',
  );
}
