import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/utils/assets.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/view_models/text_field_model.dart';
import 'package:workout_player/widgets/widgets.dart';

class SignUpWithEmailScreen extends ConsumerStatefulWidget {
  final Animation<double> animation;

  const SignUpWithEmailScreen({
    Key? key,
    required this.animation,
  }) : super(key: key);

  @override
  ConsumerState<SignUpWithEmailScreen> createState() =>
      _SignUpWithEmailScreenState();
}

class _SignUpWithEmailScreenState extends ConsumerState<SignUpWithEmailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(signInWithEmailModelProvider).signUpInit();
    // model.signUpInit();
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
        BlurredImage(
          imageProvider: AdaptiveCachedNetworkImage.provider(
            context,
            imageUrl: Assets.bgURL[2],
          ),
          bgBlurSigma: 25,
        ),
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
    final model = ref.watch(signInWithEmailModelProvider);
    final isIOS = Platform.isIOS;

    return KeyboardActionsConfig(
      keyboardSeparatorColor: ThemeColors.grey700,
      keyboardBarColor: isIOS ? ThemeColors.keyboard : theme.backgroundColor,
      actions: List.generate(
        model.signUpFocusNodes.length,
        (index) => KeyboardActionsItem(
          displayDoneButton: false,
          focusNode: model.signUpFocusNodes[index],
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
    final textFieldModel = ref.watch(textFieldModelProvider);
    final model = ref.watch(signInWithEmailModelProvider);

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
          focusNode: model.focusNode1,
          controller: model.emailEditingController,
          suffixIcon: model.focusNode1.hasFocus
              ? GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    model.emailEditingController.clear();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              : null,
          onChanged: model.signInOnChanged,
          customValidator: (string) => textFieldModel.emailValidatorWithBool(
            string,
            submitted: model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          enableSuggestions: true,
          formKey: formKey,
          focusNode: model.focusNode2,
          controller: model.firstNameEditingController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          labelText: S.current.firstName,
          hintText: S.current.firstNameHintText,
          suffixIcon: model.focusNode2.hasFocus
              ? GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    model.firstNameEditingController.clear();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              : null,
          onChanged: model.signInOnChanged,
          customValidator: (string) =>
              textFieldModel.firstNameValidatorWithBool(
            string,
            submitted: model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          enableSuggestions: true,
          focusNode: model.focusNode3,
          controller: model.lastNameEditingController,
          formKey: formKey,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          labelText: S.current.lastName,
          hintText: S.current.lastNameHintText,
          suffixIcon: model.focusNode3.hasFocus
              ? GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    model.lastNameEditingController.clear();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              : null,
          onChanged: model.signInOnChanged,
          customValidator: (string) => textFieldModel.lastNameValidatorWithBool(
            string,
            submitted: model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          autocorrect: false,
          obscureText: true,
          maxLines: 1,
          focusNode: model.focusNode4,
          controller: model.passwordEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          formKey: formKey,
          labelText: S.current.password,
          hintText: S.current.passwordHintText,
          suffixIcon: model.focusNode4.hasFocus
              ? GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    model.lastNameEditingController.clear();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              : null,
          onChanged: model.signInOnChanged,
          customValidator: (string) => textFieldModel.passwordValidatorWithBool(
            string,
            submitted: model.submitted,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 36),
        child: MaxWidthRaisedButton(
          radius: 24,
          buttonText: S.current.signUp,
          onPressed: () async {
            final status = await model.signUpWithEmail();

            if (!mounted) return;

            if (status.statusCode == 200) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (status.exception is FirebaseException) {
              final e = status.exception as FirebaseException;

              showSignInError(e, context);
            }
          },
          color: theme.primaryColor,
        ),
      ),
      TermsAndPrivacyPolicyWidget(model: model),
    ];
  }
}
