import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';

import '../sign_in_with_email_model.dart';

class EmailSignUpScreen extends StatefulWidget {
  final SignInWithEmailModel model;

  EmailSignUpScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => Consumer(
          builder: (context, ref, child) => EmailSignUpScreen(
            model: ref.watch(signInWithEmailModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _EmailSignUpScreenState createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.signUpInit();
  }

  @override
  void dispose() {
    widget.model.signUpDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(S.current.signUp, style: TextStyles.subtitle2),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.model.toggleSubmitted();
          },
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
    final locale = Intl.getCurrentLocale();

    // bool _showEmailErrorText = widget.model.isLoading &&
    //     !widget.validator
    //         .isEmailValid(widget.model.emailEditingController.text);
    // String? _emailErrorText =
    //     _showEmailErrorText ? widget.invalidEmailText : null;

    // bool _showFirstNameErrorText = widget.model.isLoading &&
    //     !widget.validator
    //         .isFirstNameValid(widget.model.firstNameEditingController.text);
    // String? _firstNameErrorText =
    //     _showFirstNameErrorText ? S.current.firstNameValidationText : null;

    // bool _showLastNameErrorText = widget.model.isLoading &&
    //     !widget.validator
    //         .isLastNameValid(widget.model.lastNameEditingController.text);
    // String? _lastNameErrorText =
    //     _showLastNameErrorText ? S.current.lastNameValidationText : null;

    // bool _showPaswordErrorText = widget.model.isLoading &&
    //     !widget.validator
    //         .isPasswordValid(widget.model.passwordEditingController.text);
    // String? _passwordErrorText =
    //     _showPaswordErrorText ? widget.emptyPasswordText : null;

    return KeyboardActions(
      config: _buildConfig(),
      child: SingleChildScrollView(
        child: Form(
          key: widget.model.signUpWithEmailFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EMAIL
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.emailAddress,
                    style: TextStyles.subtitle2,
                  ),
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
                    // errorText: _emailErrorText,
                    hintText: 'JohnDoe@abc.com',
                    hintStyle: kBodyText1Grey,
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
                  style: kBodyText1Bold,
                  onChanged: widget.model.signUpScreenValidate,
                ),
                const SizedBox(height: 8),

                // FIRST NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.firstName, style: TextStyles.subtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: true,
                  focusNode: widget.model.focusNode2,
                  controller: widget.model.firstNameEditingController,
                  keyboardType: TextInputType.name,
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
                    errorText: widget.model.firstNameErrorText,
                    hintText: S.current.firstNameHintText,
                    hintStyle: kBodyText1Grey,
                    suffixIcon: widget.model.focusNode2.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              widget.model.firstNameEditingController.clear();
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
                  onChanged: widget.model.signUpScreenValidate,
                ),
                const SizedBox(height: 8),

                // LAST NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.current.lastName, style: TextStyles.subtitle2),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: true,
                  focusNode: widget.model.focusNode3,
                  controller: widget.model.lastNameEditingController,
                  keyboardType: TextInputType.name,
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
                    errorText: widget.model.lastNameErrorText,
                    hintText: S.current.lastNameHintText,
                    hintStyle: kBodyText1Grey,
                    suffixIcon: widget.model.focusNode3.hasFocus
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              widget.model.lastNameEditingController.clear();
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
                  onChanged: widget.model.signUpScreenValidate,
                ),
                const SizedBox(height: 8),

                // PASSWORD
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.passwordAllCap,
                    style: TextStyles.subtitle2,
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  focusNode: widget.model.focusNode4,
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
                    hintStyle: kBodyText1Grey,
                    suffixIcon: widget.model.focusNode4.hasFocus
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
                  style: kBodyText1Bold,
                  onChanged: widget.model.signUpScreenValidate,
                ),

                const SizedBox(height: 8),

                // PasswordStrengthMeter(),

                // Text(
                //   estimatePasswordStrength(_password).toString(),
                //   style: kBodyText1,
                // ),

                // SUBMIT BUTTON
                const SizedBox(height: 36),
                MaxWidthRaisedButton(
                  buttonText: S.current.signUp,
                  onPressed: widget.model.signUpScreenStringsValid
                      ? () => widget.model.signUpWithEmail(context)
                      : null,
                  color: kPrimary600Color,
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: S.current.acceptingTermsEmail,
                      style: TextStyles.overline_grey,
                      children: <TextSpan>[
                        TextSpan(
                          text: S.current.terms,
                          style: TextStyles.overline_gery_underlined,
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.model.launchTermsURL,
                        ),
                        TextSpan(
                          text: S.current.and,
                          style: TextStyles.overline_grey,
                        ),
                        TextSpan(
                          text: S.current.privacyPolicy,
                          style: TextStyles.overline_gery_underlined,
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.model.launchPrivacyServiceURL,
                        ),
                        if (locale == 'ko')
                          TextSpan(
                            text: S.current.acepptingTermsKorean,
                            style: TextStyles.overline_grey,
                          ),
                      ],
                    ),
                  ),
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
        KeyboardActionsItem(
          focusNode: widget.model.focusNode3,
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
          focusNode: widget.model.focusNode4,
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
