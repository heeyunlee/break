import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/view_models/text_field_model.dart';

class SignUpWithEmailScreen extends StatefulWidget {
  final SignInWithEmailModel model;
  final TextFieldModel textFieldModel;

  const SignUpWithEmailScreen({
    Key? key,
    required this.model,
    required this.textFieldModel,
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
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        title: Text(S.current.signUp, style: TextStyles.subtitle2),
        leading: const AppBarBackButton(),
      ),
      backgroundColor: kBackgroundColor,
      body: Builder(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const BlurredBackgroundPreviewWidget(blur: 25),
        SafeArea(
          child: Theme(
            data: ThemeData(
              disabledColor: kGrey700,
              iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
            ),
            child: KeyboardActions(
              config: _buildConfig(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: SignInWithEmailModel.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: Scaffold.of(context).appBarMaxHeight! + 8,
                        // ),
                        AnimatedListViewBuilder(
                          beginOffset: Offset(0.25, 0),
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
        ),
      ],
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      nextFocus: true,
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
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
    final formKey = SignInWithEmailModel.formKey;

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autofocus: true,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: 'JohnDoe@abc.com',
          labelText: S.current.email,
          formKey: formKey,
          focusNode: widget.model.focusNode1,
          controller: widget.model.emailEditingController,
          // model: widget.textFieldModel,
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
            widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          enableSuggestions: true,
          // model: widget.textFieldModel,
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
            widget.model.submitted,
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
          // model: widget.textFieldModel,
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
            widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          maxLines: 1,
          focusNode: widget.model.focusNode4,
          controller: widget.model.passwordEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          // model: widget.textFieldModel,
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
            widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 36),
        child: MaxWidthRaisedButton(
          radius: 24,
          buttonText: S.current.signUp,
          onPressed: () => widget.model.signUpWithEmail(context),
          color: kPrimary600Color,
        ),
      ),
      TermsAndPrivacyPolicyWidget(model: widget.model),
    ];
  }
}
