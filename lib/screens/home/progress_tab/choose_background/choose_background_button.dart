import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/choose_background/choose_background_screen.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ChooseBackgroundButton extends StatelessWidget {
  final User user;

  const ChooseBackgroundButton({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      featureId: 'choose_background',
      tapTarget: const Icon(Icons.wallpaper_rounded),
      title: Text(S.current.changeBackground, style: TextStyles.headline6),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You can choose different backgrounds for this tab using this button',
            style: TextStyles.body2,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyles.elevated_blue_accent,
            onPressed: () => FeatureDiscovery.completeCurrentStep(context),
            child: Text(S.current.next, style: TextStyles.button1),
          ),
        ],
      ),
      // backgroundDismissible: true,
      overflowMode: OverflowMode.clipContent,
      backgroundColor: kPrimaryColor,
      targetColor: kPrimary300Color,
      textColor: Colors.white,
      // backgroundOpacity: 0.95,
      // onComplete: () async {
      //   await FeatureDiscovery.clearPreferences(context, <String>{
      //     'choose_background',
      //   });
      //   return true;
      // },
      child: IconButton(
        onPressed: () => ChooseBackgroundScreen.show(
          context,
          user: user,
        ),
        icon: const Icon(Icons.wallpaper_rounded),
      ),
    );
  }
}
