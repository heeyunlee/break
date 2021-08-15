import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/combined/auth_and_database.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../screens/customize_widgets_screen.dart';

class CustomizeWidgetsButton extends StatelessWidget {
  final User user;
  final AuthAndDatabase authAndDatabase;

  const CustomizeWidgetsButton({
    Key? key,
    required this.user,
    required this.authAndDatabase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      featureId: 'customize_widgets',
      tapTarget: const Icon(Icons.dashboard_customize_rounded),
      title: Text(
        S.current.featureDiscoveryCustomizeWidgetTitle,
        style: TextStyles.headline6,
      ),
      description: Text(
        S.current.featureDiscoveryCustomizeWidgetMessage,
        style: TextStyles.body1,
      ),
      backgroundColor: kSecondaryColor,
      targetColor: kPrimaryColor,
      textColor: Colors.white,
      child: IconButton(
        onPressed: () => CustomizeWidgetsScreen.show(
          context,
          user: user,
          authAndDatabase: authAndDatabase,
        ),
        icon: const Icon(Icons.dashboard_customize_rounded),
      ),
    );
  }
}
