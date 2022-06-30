import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => ChangeEmailScreen(user: user),
    );
  }

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _email;

  late TextEditingController _textController1;
  late FocusNode focusNode1;

  @override
  void initState() {
    _email = widget.user.userEmail ?? '';
    _textController1 = TextEditingController(text: _email);
    focusNode1 = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Submit data to Firestore
  Future<void> _updateUserName() async {
    if (_validateAndSaveForm()) {
      try {
        final database = ref.watch(databaseProvider);
        final user = {
          'userEmail': _email,
        };
        await database.updateUser(database.uid!, user);

        // TODO(heeyunlee): add snackbar
        // // SnackBar
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(S.current.updateEmailSnackbar),
        //   duration: const Duration(seconds: 2),
        //   behavior: SnackBarBehavior.floating,
        // ));
      } on FirebaseException catch (e) {
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.editEmail, style: TextStyles.subtitle1),
        leading: const AppBarBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              style: TextStyles.headline5,
              autofocus: true,
              textAlign: TextAlign.center,
              controller: _textController1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.current.emptyEmailValidationText;
                }
                if (!EmailValidator.validate(_email)) {
                  return S.current.invalidEmailValidationText;
                }
                return null;
              },
              decoration: InputDecoration(
                hintStyle: TextStyles.headline6Grey,
                hintText: 'JohnDoe@abc.com',
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                counterStyle: TextStyles.caption1Grey,
              ),
              onChanged: (value) => setState(() {
                _email = value;
              }),
              onSaved: (value) => setState(() {
                _email = value!;
              }),
              onFieldSubmitted: (value) {
                setState(() {
                  _email = value;
                });
                _updateUserName();
              },
            ),
          ),
        ],
      ),
    );
  }
}
