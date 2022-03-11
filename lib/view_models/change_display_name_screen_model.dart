import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/basic.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

class ChangeDisplayNameScreenModel with ChangeNotifier {
  ChangeDisplayNameScreenModel({
    required this.database,
    required this.user,
  });

  final User user;
  final Database database;

  late TextEditingController _textController;
  late FocusNode _focusNode;

  TextEditingController get textController => _textController;
  FocusNode get focusNode => _focusNode;

  void init() {
    _textController = TextEditingController(text: user.displayName);
    _focusNode = FocusNode();
  }

  void onFieldSubmitted(BuildContext context, String value) {
    updateDisplayName(context);
  }

  Future<void> updateDisplayName(BuildContext context) async {
    if (_textController.text.isNotEmpty) {
      try {
        final updatedUser = {
          'displayName': _textController.text,
        };

        await database.updateUser(database.uid!, updatedUser);

        getSnackbarWidget(
          S.current.updateDisplayNameSnackbarTitle,
          S.current.updateDisplayNameSnackbar,
        );
      } on FirebaseException catch (e) {
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.displayNameEmptyTitle,
        content: S.current.displayNameEmptyContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  static final formKey = GlobalKey<FormState>();
}
