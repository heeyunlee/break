import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/preview/widgets/blurred_background_preview_widget.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/view_models/text_field_model.dart';

class SignUpWithEmailScreen extends StatefulWidget {
  final SignInWithEmailModel model;
  final TextFieldModel textFieldModel;
  final Animation<double> animation;

  const SignUpWithEmailScreen({
    Key? key,
    required this.model,
    required this.textFieldModel,
    required this.animation,
  }) : super(key: key);

  @override
  _SignUpWithEmailScreenState createState() => _SignUpWithEmailScreenState();
}

class _SignUpWithEmailScreenState extends State<SignUpWithEmailScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.signUpInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(S.current.signUp, style: TextStyles.subtitle2),
        leading: const AppBarBackButton(),
      ),
      body: Builder(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const BlurredBackgroundPreviewWidget(blur: 25),
        SafeArea(
          child: KeyboardActions(
            config: _buildConfig(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: SignInWithEmailModel.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedListViewBuilder(
                        animation: widget.animation,
                        beginOffset: const Offset(0.25, 0),
                        offsetInitialDelayTime: 0.25,
                        offsetStaggerTime: 0.05,
                        offsetDuration: 0.5,
                        items: _widgets(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return KeyboardActionsConfig(
      keyboardSeparatorColor: ThemeColors.grey700,
      keyboardBarColor: isIOS ? ThemeColors.keyboard : theme.backgroundColor,
      actions: List.generate(
        widget.model.signUpFocusNodes.length,
        (index) => KeyboardActionsItem(
          displayDoneButton: false,
          focusNode: widget.model.signUpFocusNodes[index],
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(onTap: node.unfocus),
          ],
        ),
      ),
    );
  }

  List<Widget> _widgets() {
    final theme = Theme.of(context);
    final formKey = SignInWithEmailModel.formKey;

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: 'JohnDoe@abc.com',
          labelText: S.current.email,
          formKey: formKey,
          focusNode: widget.model.focusNode1,
          controller: widget.model.emailEditingController,
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
          onChanged: widget.model.signInOnChanged,
          customValidator: (string) =>
              widget.textFieldModel.emailValidatorWithBool(
            string,
            submitted: widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          enableSuggestions: true,
          formKey: formKey,
          focusNode: widget.model.focusNode2,
          controller: widget.model.firstNameEditingController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          labelText: S.current.firstName,
          hintText: S.current.firstNameHintText,
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
          onChanged: widget.model.signInOnChanged,
          customValidator: (string) =>
              widget.textFieldModel.firstNameValidatorWithBool(
            string,
            submitted: widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          enableSuggestions: true,
          focusNode: widget.model.focusNode3,
          controller: widget.model.lastNameEditingController,
          formKey: formKey,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          labelText: S.current.lastName,
          hintText: S.current.lastNameHintText,
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
          onChanged: widget.model.signInOnChanged,
          customValidator: (string) =>
              widget.textFieldModel.lastNameValidatorWithBool(
            string,
            submitted: widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          obscureText: true,
          maxLines: 1,
          focusNode: widget.model.focusNode4,
          controller: widget.model.passwordEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          formKey: formKey,
          labelText: S.current.password,
          hintText: S.current.passwordHintText,
          suffixIcon: widget.model.focusNode4.hasFocus
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
          onChanged: widget.model.signInOnChanged,
          customValidator: (string) =>
              widget.textFieldModel.passwordValidatorWithBool(
            string,
            submitted: widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 36),
        child: MaxWidthRaisedButton(
          radius: 24,
          buttonText: S.current.signUp,
          onPressed: () => widget.model.signUpWithEmail(context),
          color: theme.primaryColor,
        ),
      ),
      TermsAndPrivacyPolicyWidget(model: widget.model),
    ];
  }
}
