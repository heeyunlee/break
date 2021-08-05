import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/models/text_field_model.dart';
import 'package:workout_player/screens/preview/widgets/blurred_background_preview_widget.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/animated_list_view_builder.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/widgets/keyboard_actions_done_button.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/widgets/text_field/outlined_text_text_field_widget.dart';

import 'sign_in_with_email_model.dart';

class SignInWithEmailScreen extends StatefulWidget {
  final SignInWithEmailModel model;
  final TextFieldModel textFieldModel;

  const SignInWithEmailScreen({
    Key? key,
    required this.model,
    required this.textFieldModel,
  }) : super(key: key);

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
    logger.d('Log In With Email building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
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
        Theme(
          data: ThemeData(
            disabledColor: kGrey700,
            iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
          ),
          child: KeyboardActions(
            config: _buildConfig(),
            child: SingleChildScrollView(
              child: Form(
                key: SignInWithEmailModel.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: Scaffold.of(context).appBarMaxHeight!),
                      AnimatedListViewBuilder(
                        beginOffset: Offset(0.25, 0),
                        offsetStartInterval: 0.25,
                        offsetDelay: 0.05,
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

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: kGrey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
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
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          model: widget.textFieldModel,
          formKey: SignInWithEmailModel.formKey,
          autofocus: true,
          enableSuggestions: false,
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
            widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          maxLines: 1,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          focusNode: widget.model.focusNode2,
          controller: widget.model.passwordEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          model: widget.textFieldModel,
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
            widget.model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 32),
        child: MaxWidthRaisedButton(
          radius: 24,
          buttonText: S.current.logIn,
          onPressed: () => widget.model.signInWithEmailAndPassword(context),
          color: kPrimary600Color,
        ),
      ),
    ];
  }
}
