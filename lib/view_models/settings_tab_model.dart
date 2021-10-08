import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

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
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

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
        await auth!.currentUser!.delete();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        await auth!.signOut();
      }

      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.signOutSnackbarTitle,
        S.current.signOutSnackbarMessage,
      );
    } catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: S.current.signOutFailedMessage,
      );
    }
  }

  // TODO: CHANGE VERSION CODE HERE
  void showAboutDialogOfApp(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: S.current.applicationName,
      applicationVersion: 'v.0.3.6+1',
      applicationIcon: SvgPicture.asset(
        'assets/svgs/break_logo.svg',
        width: 36,
        height: 36,
      ),
    );
  }
}
