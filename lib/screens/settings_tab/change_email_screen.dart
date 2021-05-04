import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';

Logger logger = Logger();

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({
    Key key,
    @required this.database,
    @required this.user,
    @required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show(BuildContext context, {User user}) async {
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

  String _email;

  var _textController1 = TextEditingController();
  FocusNode focusNode1;

  @override
  void initState() {
    _email = widget.user.userEmail;
    _textController1 = TextEditingController(text: _email);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
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
        await widget.database.updateUser(widget.auth.currentUser.uid, user);

        debugPrint('Updated userEmail');

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.updateEmailSnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.d(e);
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
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.editEmail, style: Subtitle1),
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
              style: Headline5,
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
                hintStyle: SearchBarHintStyle,
                hintText: 'JohnDoe@abc.com',
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: SecondaryColor),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                counterStyle: Caption1Grey,
              ),
              onChanged: (value) => setState(() {
                _email = value;
              }),
              onSaved: (value) => setState(() {
                _email = value;
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
