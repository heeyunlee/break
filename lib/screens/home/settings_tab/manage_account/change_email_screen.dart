import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../styles/constants.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({
    Key? key,
    required this.database,
    required this.user,
    required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show(BuildContext context, {required User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChangeEmailScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
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
        final user = {
          'userEmail': _email,
        };
        await widget.database.updateUser(widget.auth.currentUser!.uid, user);

        // debugPrint('Updated userEmail');

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.updateEmailSnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.editEmail, style: kSubtitle1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                hintStyle: kSearchBarHintStyle,
                hintText: 'JohnDoe@abc.com',
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                counterStyle: TextStyles.caption1_grey,
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
