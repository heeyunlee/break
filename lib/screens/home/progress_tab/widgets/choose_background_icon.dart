import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/choose_background/choose_background_screen.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ChooseBackgroundIcon extends StatelessWidget {
  final User user;

  const ChooseBackgroundIcon({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DescribedFeatureOverlay(
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
        backgroundColor: kPrimary800Color,
        targetColor: kPrimaryColor,
        textColor: Colors.white,
        onComplete: () async {
          await FeatureDiscovery.clearPreferences(context, <String>{
            'choose_background',
          });
          return true;
        },
        child: IconButton(
          onPressed: () => ChooseBackgroundScreen.show(
            context,
            user: user,
          ),
          icon: const Icon(Icons.wallpaper_rounded),
        ),
      ),
    );
  }
}
