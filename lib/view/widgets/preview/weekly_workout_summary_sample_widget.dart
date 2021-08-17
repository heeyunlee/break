import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

class WeeklyWorkoutSummarySampleWidget extends StatelessWidget {
  final Color? color;
  final double? padding;

  const WeeklyWorkoutSummarySampleWidget({
    Key? key,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _weekDaysOfTheWeek = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    List<String> _daysOfTheWeek = [
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
    ];

    List<String?> _weeklyWorkedOutMuscles = [
      null,
      S.current.chest,
      S.current.back,
      S.current.lats,
      null,
      S.current.chest,
      S.current.back,
    ];

    return BlurBackgroundCard(
      color: color,
      allPadding: padding,
      borderRadius: 28,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: kPrimaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    S.current.wokroutsThisWeek,
                    style: TextStyles.subtitle1_w900_primary,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: kPrimaryColor,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (index) => Column(
                  children: [
                    Text(
                      _weekDaysOfTheWeek[index],
                      style: TextStyles.body2_grey_bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: CircleAvatar(
                        backgroundColor:
                            (_weeklyWorkedOutMuscles[index] != null)
                                ? kPrimaryColor
                                : Colors.transparent,
                        maxRadius: 16,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: FittedBox(
                            child: Text(
                              _weeklyWorkedOutMuscles[index] ??
                                  _daysOfTheWeek[index].toString(),
                              style: TextStyles.caption1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
