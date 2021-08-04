import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/sign_in/sign_in_screen_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class LogoWidget extends StatelessWidget {
  final SignInScreenModel model;

  const LogoWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _loadingWidget = [
      const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      ),
      const SizedBox(height: 24),
      Text(S.current.signingIn, style: TextStyles.body2),
    ];

    final List<Widget> _logoWidget = [
      Hero(
        tag: 'logo',
        child: SvgPicture.asset(
          'assets/svgs/herakles_icon.svg',
          width: 72,
        ),
      ),
      const SizedBox(height: 40),
      const Text('Herakles: Workout Player', style: TextStyles.subtitle1_menlo),
    ];

    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: model.isLoading ? _loadingWidget : _logoWidget,
        ),
      ),
    );
  }
}