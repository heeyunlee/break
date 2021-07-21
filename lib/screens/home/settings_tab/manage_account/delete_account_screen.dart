import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';

import '../../../../styles/constants.dart';

class DeleteAccountScreen extends StatelessWidget {
  final User user;
  final AuthBase auth;

  const DeleteAccountScreen({
    Key? key,
    required this.user,
    required this.auth,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {required User user}) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => DeleteAccountScreen(
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await auth.currentUser!.delete();
      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.deleteAccountSnackbarTitle,
        S.current.deleteAccountSnackbarMessage,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            S.current.deleteAccountTitle(user.userName),
            style: TextStyles.headline6_w900,
          ),
          const SizedBox(height: 16),
          Text(S.current.byDeletingAccount, style: TextStyles.body1),
          const SizedBox(height: 8),
          Text(S.current.deletingAccountWarning1, style: TextStyles.body1),
          const SizedBox(height: 4),
          Text(S.current.deletingAccountWarning2, style: TextStyles.body1),
          const SizedBox(height: 4),
          Text(S.current.deletingAccountWarning3, style: TextStyles.body1),
          const SizedBox(height: 40),
          MaxWidthRaisedButton(
            color: Colors.red,
            onPressed: () => deleteAccount(context),
            buttonText: S.current.continueButton,
          ),
        ],
      ),
    );
  }
}
