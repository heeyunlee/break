import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/home/progress_tab/progress_tab_model.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/personal_goals_screen.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home_screen_model.dart';

class BlurredMaterialBanner extends StatelessWidget {
  final ProgressTabModel model;

  const BlurredMaterialBanner({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeContext = context
        .read(homeScreenModelProvider)
        .homeScreenNavigatorKey
        .currentContext!;

    return SizedBox(
      height: 136,
      width: size.width - 32,
      child: BlurBackgroundCard(
        borderRadius: 12,
        color: Colors.grey.withOpacity(0.25),
        child: MaterialBanner(
          backgroundColor: Colors.transparent,
          content: Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                color: kPrimaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                S.current.progressTabBannerTitle,
                style: TextStyles.body2,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyles.text1_bold,
              onPressed: () => model.setShowBanner(false),
              child: Text(S.current.DISMISS),
            ),
            TextButton(
              style: ButtonStyles.text1_bold,
              onPressed: () => PersonalGoalsScreen.show(
                homeContext,
                isRoot: true,
              ),
              child: Text(S.current.SETNOW),
            ),
          ],
        ),
      ),
    );
  }
}
