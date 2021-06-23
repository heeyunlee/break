import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'string_validator.dart';

class LogInWithEmailScreen extends StatefulWidget
    with EmailAndPasswordValidators {
  final AuthBase auth;
  final Database database;

  LogInWithEmailScreen({Key? key, required this.auth, required this.database})
      : super(key: key);

  static Future<void> show(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => LogInWithEmailScreen(
          auth: auth,
          database: database,
        ),
      ),
    );
  }

  @override
  _LogInWithEmailScreenState createState() => _LogInWithEmailScreenState();
}

class _LogInWithEmailScreenState extends State<LogInWithEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _textController1;
  late TextEditingController _textController2;

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;

  String get _email => _textController1.text;
  String get _password => _textController2.text;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    _textController1 = TextEditingController();
    _textController2 = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();

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

  Future<void> _submitLogIn() async {
    debugPrint('_submitLogIn pressed');
    if (_validateAndSaveForm()) {
      setState(() {
        submitted = true;
      });

      try {
        await widget.auth.signInWithEmailWithPassword(_email, _password);

        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };

        await widget.database.updateUser(
          widget.auth.currentUser!.uid,
          updatedUserData,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseException catch (e) {
        logger.e(e);
        _showSignInError(e, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.current.signInWithEmail, style: kSubtitle2),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    bool _showEmailErrorText =
        submitted && !widget.validator.isEmailValid(_email);
    String? _emailErrorText =
        _showEmailErrorText ? widget.invalidEmailText : null;

    bool _showPaswordErrorText =
        submitted && !widget.validator.isPasswordValid(_password);
    String? _passwordErrorText =
        _showPaswordErrorText ? widget.emptyPasswordText : null;

    return KeyboardActions(
      config: _buildConfig(),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EMAIL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.email, style: kSubtitle2),
                ),
                TextFormField(
                  autofocus: true,
                  enableSuggestions: false,
                  focusNode: _focusNode1,
                  controller: _textController1,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _emailErrorText,
                    hintText: 'JohnDoe@abc.com',
                    hintStyle: kBodyText1Grey,
                    suffixIcon: _focusNode1.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _textController1.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: kBodyText1Bold,
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 8),

                // PASSWORD
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.password, style: kSubtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  focusNode: _focusNode2,
                  controller: _textController2,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _passwordErrorText,
                    hintText: S.current.passwordHintText,
                    hintStyle: kBodyText1Grey,
                    suffixIcon: _focusNode2.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _textController2.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: kBodyText1Bold,
                  onChanged: (value) => setState(() {}),
                ),

                // SUBMIT BUTTON
                const SizedBox(height: 36),
                MaxWidthRaisedButton(
                  buttonText: S.current.logIn,
                  onPressed: widget.validator.isEmailValid(_email) &&
                          widget.validator.isPasswordValid(_password)
                      ? _submitLogIn
                      : null,
                  color: kPrimary600Color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: kButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode2,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: kButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    switch (exception.code) {
      case 'user-not-found':
        showAlertDialog(
          context,
          title: S.current.userNotFound,
          content: S.current.userNotFoundMessage,
          defaultActionText: S.current.ok,
        );
        break;
      case 'wrong-password':
        showAlertDialog(
          context,
          title: S.current.wrongPassword,
          content: S.current.wrongPasswordMessage,
          defaultActionText: S.current.ok,
        );
        break;
      case 'email-already-in-use':
        showAlertDialog(
          context,
          title: S.current.emailAlreadyInUse,
          content: S.current.emailAlreadyInUseMessage,
          defaultActionText: S.current.ok,
        );
        break;
      default:
        showAlertDialog(
          context,
          title: exception.code,
          content: exception.toString(),
          defaultActionText: S.current.ok,
        );
    }
  }
}
