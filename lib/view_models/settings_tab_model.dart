import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/firebase_auth_service.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class SettingsTabModel with ChangeNotifier {
  SettingsTabModel({required this.database, required this.auth});

  final Database database;
  final FirebaseAuthService auth;

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
      await auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.signOutSnackbarTitle,
        S.current.signOutSnackbarMessage,
      );
    } catch (e) {
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
      applicationVersion: 'v.0.3.8',
      applicationIcon: SvgPicture.asset(
        'assets/svgs/break_logo.svg',
        width: 36,
        height: 36,
      ),
    );
  }
}
