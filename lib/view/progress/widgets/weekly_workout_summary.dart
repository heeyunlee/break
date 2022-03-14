import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';

class WeeklyWorkoutSummary extends ConsumerWidget {
  const WeeklyWorkoutSummary({
    Key? key,
    required this.weeklyWorkedOutMuscles,
    this.width,
    this.height,
    this.cardOnTap,
    this.cardOnLongPress,
    this.titleOnTap,
    this.color,
  })  : assert(
          weeklyWorkedOutMuscles.length == 7,
          'weeklyWorkedOutMuscles length has to be 7',
        ),
        super(key: key);

  final List<String?> weeklyWorkedOutMuscles;
  final double? width;
  final double? height;
  final VoidCallback? cardOnTap;
  final VoidCallback? cardOnLongPress;
  final VoidCallback? titleOnTap;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topLevelVariables = ref.watch(topLevelVariablesProvider);

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: color,
        child: InkWell(
          onTap: cardOnTap,
          onLongPress: cardOnLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: titleOnTap,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.current.wokroutsThisWeek,
                          style: TextStyles.subtitle1W900RedAccent,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (index) => Column(
                      children: [
                        Text(
                          topLevelVariables.thisWeekDaysOfTheWeek[index],
                          style: TextStyles.body2GreyBold,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: CircleAvatar(
                            backgroundColor:
                                (weeklyWorkedOutMuscles[index] != null)
                                    ? Colors.redAccent
                                    : Colors.transparent,
                            maxRadius: 16,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: FittedBox(
                                child: Text(
                                  weeklyWorkedOutMuscles[index] ??
                                      topLevelVariables.thisWeekDays[index]
                                          .toString(),
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
        ),
      ),
    );
  }
}
