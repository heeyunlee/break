import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

PrefixPrinter prefixPrinter = PrefixPrinter(
  PrettyPrinter(
    methodCount: 1, // number of method calls to be displayed
    errorMethodCount: 5, // number of method calls if stacktrace is provided
    lineLength: 100, // width of the output
    printTime: true, // Should each log print contain a timestamp
  ),
  debug: '[Break][D]',
  info: '[Break][I]',
  error: '[Break][E]',
  warning: '[Break][W]',
  verbose: '[Break][V]',
  wtf: '[Break][WTF]',
);

Logger logger = Logger(
  level: Level.nothing,
  printer: prefixPrinter,
);

void initLogger(Level level) {
  logger = Logger(
    level: level,
    printer: prefixPrinter,
  );
}

class MainModel with ChangeNotifier {
  Future<void> launchTermsURL(BuildContext context) async {
    final bool canLaunchs = await canLaunch(_termsUrl);

    if (canLaunchs) {
      await launch(_termsUrl);
    } else {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: S.current.couldNotLaunch(_termsUrl),
      );
    }
  }

  Future<void> launchPrivacyServiceURL(BuildContext context) async {
    final bool canLaunchs = await canLaunch(_privacyPolicyUrl);

    if (canLaunchs) {
      await launch(_privacyPolicyUrl);
    } else {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: S.current.couldNotLaunch(_privacyPolicyUrl),
      );
    }
  }

  static const _termsUrl =
      'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
  static const _privacyPolicyUrl =
      'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';
}
