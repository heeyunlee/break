import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

class MostRecentWorkoutSampleWidget extends StatelessWidget {
  final Color? color;
  final double? padding;

  const MostRecentWorkoutSampleWidget({
    Key? key,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final locale = Intl.getCurrentLocale();

    final String ago = timeago.format(
      DateTime.now().subtract(const Duration(days: 2)),
      locale: locale,
    );

    final theme = Theme.of(context);

    return BlurBackgroundCard(
      color: color ?? theme.cardTheme.color,
      allPadding: padding,
      borderRadius: 28,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.current.routineTitleHintText, style: TextStyles.body1),
                Text(ago, style: TextStyles.overlineGrey),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '9,520 kg',
                        style: TextStyles.headline5MenloW900RedAccent,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.current.liftedWeights,
                        style: TextStyles.caption1Grey,
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.white24,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '62 ${S.current.minutes}',
                        style: TextStyles.headline5MenloW900RedAccent,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.current.time,
                        style: TextStyles.caption1Grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
