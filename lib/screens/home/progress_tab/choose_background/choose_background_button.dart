import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/choose_background/choose_background_screen.dart';
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
      title: Text(
        'New Feature!',
        style: TextStyles.headline6,
      ),
      description: Text(
        'Change background of the progress tab',
        style: TextStyles.body2,
      ),
      // backgroundDismissible: true,
      overflowMode: OverflowMode.clipContent,
      backgroundColor: kPrimary800Color,
      targetColor: kPrimaryColor,
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
