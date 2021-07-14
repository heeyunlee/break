import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';

import '../home_screen_provider.dart';
import '../tab_item.dart';

final settingsTabModelProvider = ChangeNotifierProvider(
  (ref) => SettingsTabModel(),
);

class SettingsTabModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  SettingsTabModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  static const termsUrl =
      'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
  static const privacyPolicyUrl =
      'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';

  void launchTermsURL() async => await canLaunch(termsUrl)
      ? await launch(termsUrl)
      : throw 'Could not launch $termsUrl';

  void launchPrivacyServiceURL() async => await canLaunch(privacyPolicyUrl)
      ? await launch(privacyPolicyUrl)
      : throw 'Could not launch $privacyPolicyUrl';

  Future<void> confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: S.current.logout,
      content: S.current.confirmSignOutContext,
      cancelAcitionText: S.current.cancel,
      defaultActionText: S.current.logout,
    );
    if (didRequestSignOut == true) {
      return _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      // FirebaseCrashlytics.instance.crash();
      if (auth!.currentUser!.isAnonymous) {
        // debugPrint('signed in anonymously');
        await auth!.currentUser!.delete();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        await auth!.signOut();
      }

      Navigator.of(context).pop();
      currentTab = CustomTabItem.progress;
      currentTabIndex = 0;

      getSnackbarWidget(
        S.current.signOutSnackbarTitle,
        S.current.signOutSnackbarMessage,
      );
    } catch (e) {
      // TODO: SHOW DIALOG AFTER CATCHING ERROR
      // print(e.toString());
    }
  }

  // TODO: CHANGE VERSION CODE HERE
  void showAboutDialogOfApp(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: S.current.applicationName,
      applicationVersion: 'v.0.3.3',
      applicationIcon: Container(
        decoration: BoxDecoration(color: kBackgroundColor),
        child: Image.asset('assets/logos/herakles_icon.png',
            width: 36, height: 36),
      ),
    );
  }
}
