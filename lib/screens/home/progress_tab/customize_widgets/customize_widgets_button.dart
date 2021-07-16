import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'customize_widgets_screen.dart';

class CustomizeWidgetsButton extends StatelessWidget {
  const CustomizeWidgetsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      featureId: 'customize_widgets',
      tapTarget: const Icon(Icons.dashboard_customize_rounded),
      title: Text('Customize Your Widgets', style: TextStyles.headline6),
      description: Text(
        'Now you can customize progress tab\'s widgets. Just long press the widget to reorder or press this button to delete or add a widget!',
        style: TextStyles.body1,
      ),
      backgroundColor: kSecondaryColor,
      targetColor: kPrimaryColor,
      textColor: Colors.white,
      child: IconButton(
        onPressed: () => CustomizeWidgetsScreen.show(context),
        icon: const Icon(Icons.dashboard_customize_rounded),
      ),
    );
  }
}
