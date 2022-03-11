import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/view_models/text_field_model.dart';

class SignInWithEmailScreen extends StatefulWidget {
  const SignInWithEmailScreen({
    Key? key,
    required this.model,
    required this.textFieldModel,
    required this.animation,
  }) : super(key: key);

  final SignInWithEmailModel model;
  final TextFieldModel textFieldModel;
  final Animation<double> animation;

  @override
  _SignInWithEmailScreenState createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends State<SignInWithEmailScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.signInInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(S.current.signInWithEmail, style: TextStyles.subtitle2),
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
        KeyboardActions(
          config: _buildConfig(context),
          child: SingleChildScrollView(
            child: Form(
              key: SignInWithEmailModel.formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: Scaffold.of(context).appBarMaxHeight),
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
        widget.model.signInFocusNodes.length,
        (index) => KeyboardActionsItem(
          focusNode: widget.model.signInFocusNodes[index],
          displayDoneButton: false,
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(onTap: node.unfocus),
          ],
        ),
      ),
    );
  }

  List<Widget> _widgets() {
    final theme = Theme.of(context);

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          formKey: SignInWithEmailModel.formKey,
          autofocus: true,
          focusNode: widget.model.focusNode1,
          controller: widget.model.emailEditingController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: 'JohnDoe@abc.com',
          labelText: S.current.email,
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
          maxLines: 1,
          autocorrect: false,
          obscureText: true,
          focusNode: widget.model.focusNode2,
          controller: widget.model.passwordEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          formKey: SignInWithEmailModel.formKey,
          labelText: S.current.password,
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
          onChanged: widget.model.signInOnChanged,
          customValidator: (string) =>
              widget.textFieldModel.passwordValidatorWithBool(
            string,
            submitted: widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32),
        child: MaxWidthRaisedButton(
          radius: 24,
          buttonText: S.current.logIn,
          onPressed: () => widget.model.signInWithEmailAndPassword(context),
          color: theme.primaryColor,
        ),
      ),
    ];
  }
}
