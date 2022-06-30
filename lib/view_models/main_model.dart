import 'package:flutter/material.dart';

class MainModel with ChangeNotifier {
  // Future<void> launchTermsURL(BuildContext context) async {
  //   final canLaunchs = await canLaunch(_termsUrl);

  //   if (canLaunchs) {
  //     await launch(_termsUrl);
  //   } else {
  //     await showExceptionAlertDialog(
  //       context,
  //       title: S.current.operationFailed,
  //       exception: S.current.couldNotLaunch(_termsUrl),
  //     );
  //   }
  // }

  // Future<void> launchPrivacyServiceURL(BuildContext context) async {
  //   final canLaunchs = await canLaunch(_privacyPolicyUrl);

  //   if (canLaunchs) {
  //     await launch(_privacyPolicyUrl);
  //   } else {
  //     await showExceptionAlertDialog(
  //       context,
  //       title: S.current.operationFailed,
  //       exception: S.current.couldNotLaunch(_privacyPolicyUrl),
  //     );
  //   }
  // }

  // static const _termsUrl =
  //     'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
  // static const _privacyPolicyUrl =
  //     'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';
}

const termsUrl =
    'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
const privacyPolicyUrl =
    'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';
