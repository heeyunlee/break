import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/sign_in_screen_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class SignInLogoWidget extends StatelessWidget {
  final SignInScreenModel model;

  const SignInLogoWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: model.isLoading ? _loadingWidget() : _logoWidget(),
        ),
      ),
    );
  }

  List<Widget> _loadingWidget() {
    return [
      kPrimaryColorCircularProgressIndicator,
      const SizedBox(height: 24),
      Text(S.current.signingIn, style: TextStyles.body2),
    ];
  }

  List<Widget> _logoWidget() {
    return [
      Hero(
        tag: 'logo',
        child: SvgPicture.asset(
          'assets/svgs/break_logo.svg',
          width: 48,
        ),
      ),
      const SizedBox(height: 40),
      const Text(
        'Break Your Fitness Goals',
        style: TextStyles.subtitle1Menlo,
      ),
    ];
  }
}
