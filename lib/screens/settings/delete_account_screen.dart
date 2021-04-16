import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';

import '../../constants.dart';

Logger logger = Logger();

class DeleteAccountScreen extends StatelessWidget {
  final User user;
  final AuthBase auth;

  const DeleteAccountScreen({
    Key key,
    this.user,
    this.auth,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {User user}) async {
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
      await auth.currentUser.delete();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      logger.d(e);
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
      backgroundColor: BackgroundColor,
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
            style: Headline6w900,
          ),
          const SizedBox(height: 16),
          Text(S.current.byDeletingAccount, style: BodyText1),
          const SizedBox(height: 8),
          Text(S.current.deletingAccountWarning1, style: BodyText1),
          const SizedBox(height: 4),
          Text(S.current.deletingAccountWarning2, style: BodyText1),
          const SizedBox(height: 4),
          Text(S.current.deletingAccountWarning3, style: BodyText1),
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
