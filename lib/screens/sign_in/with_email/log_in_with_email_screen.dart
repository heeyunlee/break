import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';

import 'sign_in_with_email_model.dart';

class LogInWithEmailScreen extends StatefulWidget {
  final SignInWithEmailModel model;

  LogInWithEmailScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => Consumer(
          builder: (context, watch, child) => LogInWithEmailScreen(
            model: watch(signInWithEmailModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _LogInWithEmailScreenState createState() => _LogInWithEmailScreenState();
}

class _LogInWithEmailScreenState extends State<LogInWithEmailScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.signInInit();
  }

  @override
  void dispose() {
    widget.model.signInDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Log In With Email building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.current.signInWithEmail, style: TextStyles.subtitle2),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.model.toggleSubmitted();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return KeyboardActions(
      config: _buildConfig(),
      child: SingleChildScrollView(
        child: Form(
          key: widget.model.signInWithEmailFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EMAIL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.email, style: TextStyles.subtitle2),
                ),
                TextFormField(
                  autofocus: true,
                  enableSuggestions: false,
                  focusNode: widget.model.focusNode1,
                  controller: widget.model.emailEditingController,
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
                    errorText: widget.model.emailErrorText,
                    hintText: 'JohnDoe@abc.com',
                    hintStyle: TextStyles.body1_grey,
                    suffixIcon: widget.model.focusNode1.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              widget.model.emailEditingController.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: TextStyles.body1_bold,
                  onChanged: widget.model.signInScreenValidate,
                ),
                const SizedBox(height: 8),

                // PASSWORD
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.password, style: TextStyles.subtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  focusNode: widget.model.focusNode2,
                  controller: widget.model.passwordEditingController,
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
                    errorText: widget.model.passwordErrorText,
                    hintText: S.current.passwordHintText,
                    hintStyle: TextStyles.body1_grey,
                    suffixIcon: widget.model.focusNode2.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              widget.model.passwordEditingController.clear();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  style: TextStyles.body1_bold,
                  onChanged: widget.model.signInScreenValidate,
                ),

                // SUBMIT BUTTON
                const SizedBox(height: 36),
                MaxWidthRaisedButton(
                  buttonText: S.current.logIn,
                  onPressed: widget.model.signInScreenStringsValid
                      ? () => widget.model.signInWithEmailAndPassword(context)
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
          focusNode: widget.model.focusNode1,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: widget.model.focusNode2,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
