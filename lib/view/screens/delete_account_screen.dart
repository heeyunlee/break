import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/firebase_auth_service.dart';

class DeleteAccountScreen extends ConsumerWidget {
  final User user;

  const DeleteAccountScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  static void show(BuildContext context, {required User user}) async {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => DeleteAccountScreen(user: user),
    );
  }

  Future<void> deleteAccount(
    BuildContext context,
    FirebaseAuthService auth,
  ) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        elevation: 0,
      ),
      body: _buildBody(context, ref.watch(firebaseAuthProvider)),
    );
  }

  Widget _buildBody(BuildContext context, FirebaseAuthService auth) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            S.current.deleteAccountTitle(user.userName),
            style: TextStyles.headline6W900,
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
            onPressed: () => deleteAccount(context, auth),
            buttonText: S.current.continueButton,
          ),
        ],
      ),
    );
  }
}
