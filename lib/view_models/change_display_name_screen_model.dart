import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/basic.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

import 'main_model.dart';

final changeDisplayNameScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<ChangeDisplayNameScreenModel, User>(
  (ref, user) => ChangeDisplayNameScreenModel(user: user),
);

class ChangeDisplayNameScreenModel with ChangeNotifier {
  ChangeDisplayNameScreenModel({required this.user});

  final User user;

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

  Future<bool?> updateDisplayName(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    if (_textController.text.isNotEmpty) {
      try {
        final updatedUser = {
          'displayName': _textController.text,
        };

        await database.updateUser(auth.currentUser!.uid, updatedUser);

        getSnackbarWidget(
          S.current.updateDisplayNameSnackbarTitle,
          S.current.updateDisplayNameSnackbar,
        );
      } on FirebaseException catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      return showAlertDialog(
        context,
        title: S.current.displayNameEmptyTitle,
        content: S.current.displayNameEmptyContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  static final formKey = GlobalKey<FormState>();
}
