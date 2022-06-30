import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class SignInWithEmailScreen extends ConsumerStatefulWidget {
  const SignInWithEmailScreen({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  @override
  ConsumerState<SignInWithEmailScreen> createState() =>
      _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends ConsumerState<SignInWithEmailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(signInWithEmailModelProvider).signInInit();
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
        BlurredImage(
          imageProvider: AdaptiveCachedNetworkImage.provider(
            context,
            imageUrl: Assets.bgURL[2],
          ),
          bgBlurSigma: 25,
        ),
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
    final model = ref.watch(signInWithEmailModelProvider);
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return KeyboardActionsConfig(
      keyboardSeparatorColor: ThemeColors.grey700,
      keyboardBarColor: isIOS ? ThemeColors.keyboard : theme.backgroundColor,
      actions: List.generate(
        model.signInFocusNodes.length,
        (index) => KeyboardActionsItem(
          focusNode: model.signInFocusNodes[index],
          displayDoneButton: false,
          toolbarButtons: [
            (node) => KeyboardActionsDoneButton(onTap: node.unfocus),
          ],
        ),
      ),
    );
  }

  List<Widget> _widgets() {
    final model = ref.watch(signInWithEmailModelProvider);
    final textFieldModel = ref.watch(textFieldModelProvider);
    final theme = Theme.of(context);

    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedTextTextFieldWidget(
          formKey: SignInWithEmailModel.formKey,
          autofocus: true,
          focusNode: model.focusNode1,
          controller: model.emailEditingController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: 'JohnDoe@abc.com',
          labelText: S.current.email,
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
          maxLines: 1,
          autocorrect: false,
          obscureText: true,
          focusNode: model.focusNode2,
          controller: model.passwordEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          formKey: SignInWithEmailModel.formKey,
          labelText: S.current.password,
          suffixIcon: model.focusNode2.hasFocus
              ? GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    model.passwordEditingController.clear();
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
        padding: const EdgeInsets.only(top: 32),
        child: MaxWidthRaisedButton(
          radius: 24,
          buttonText: S.current.logIn,
          onPressed: () async {
            final status = await model.signInWithEmailAndPassword();

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
    ];
  }
}
