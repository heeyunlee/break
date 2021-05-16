import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/miniplayer/widgets/empty_workout_set_widget.dart';
import 'package:workout_player/screens/miniplayer/widgets/next_routine_workout_button.dart';
import 'package:workout_player/screens/miniplayer/widgets/pause_or_play_button.dart';
import 'package:workout_player/screens/miniplayer/widgets/rest_timer_widget.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/show_adaptive_modal_bottom_sheet.dart';

import '../../constants.dart';
import '../../format.dart';
import 'widgets/linear_progress_indicator_widget.dart';
import 'widgets/weights_and_reps_widget.dart';
import 'widgets/next_workout_set_button.dart';
import 'widgets/previous_workout_button.dart';
import 'widgets/previous_workout_set_button.dart';
import 'widgets/save_and_exit_button.dart';
import 'provider/workout_miniplayer_provider.dart';

class WorkoutMiniplayer extends ConsumerWidget {
  final Database database;
  final Future<User?> user;

  WorkoutMiniplayer({
    required this.database,
    required this.user,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final miniplayerController = watch(miniplayerControllerProvider).state;
    final routine = watch(selectedRoutineProvider).state;

    return Miniplayer(
      controller: miniplayerController,
      minHeight: miniplayerMinHeight,
      maxHeight: size.height,
      backgroundColor: Colors.transparent,
      valueNotifier: miniplayerExpandProgress,
      elevation: 6,
      builder: (height, percentage) {
        debugPrint('height $height, and percentage is $percentage');

        if (routine == null) {
          return const SizedBox.shrink();
        }

        if (percentage == 0) {
          return _collapsedPlayer(context, watch);
        }

        return _expandedPlayer(context, watch);
      },
    );
  }

  Widget _collapsedPlayer(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final routine = watch(selectedRoutineProvider).state!;
    final routineWorkout = watch(currentRoutineWorkoutProvider).state;
    final workoutSet = watch(currentWorkoutSetProvider).state;

    if (workoutSet != null) {
      final reps = '${workoutSet.reps} ${S.current.x}';
      final restTime = '${workoutSet.restTime} ${S.current.seconds}';
      final unit = Format.unitOfMass(routine.initialUnitOfMass);
      final formattedWeights = '${Format.weights(workoutSet.weights!)} $unit';
      return Container(
        color: kBottomNavBarColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicatorWidget(
              width: size.width,
              radius: 0.00,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!workoutSet.isRest)
                        Row(
                          children: [
                            Text(formattedWeights, style: kBodyText1w800),
                            const SizedBox(width: 8),
                            const Text('•', style: kBodyText1w800),
                            const SizedBox(width: 8),
                            Text(reps, style: kBodyText1w800),
                          ],
                        ),
                      if (workoutSet.isRest)
                        Row(
                          children: [
                            Text(restTime, style: kBodyText1w800),
                          ],
                        ),
                      const SizedBox(height: 2),
                      Text(routineWorkout!.workoutTitle, style: kBodyText2Grey),
                    ],
                  ),
                ),
                Spacer(),
                PauseOrPlayButton(iconSize: 40),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        color: kBottomNavBarColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LinearProgressIndicatorWidget(
              width: size.width,
              radius: 0.00,
            ),
            const SizedBox(height: 8),
            Text(S.current.noWorkoutSetTitle, style: kBodyText1),
          ],
        ),
      );
    }
  }

  Widget _expandedPlayer(BuildContext context, ScopedReader watch) {
    final f = NumberFormat('#,###');
    final size = MediaQuery.of(context).size;
    final locale = Intl.getCurrentLocale();

    final routine = watch(selectedRoutineProvider).state!;
    final routineWorkout = watch(currentRoutineWorkoutProvider).state!;
    final workoutSet = watch(currentWorkoutSetProvider).state;
    final miniplayerIndex = watch(miniplayerIndexProvider);

    final setTitle = (workoutSet == null)
        ? S.current.noWorkoutSetTitle
        : (workoutSet.isRest)
            ? S.current.rest
            : '${S.current.set} ${workoutSet.setIndex}';

    final translation = routineWorkout.translated;
    final title = (translation.isEmpty)
        ? routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? routineWorkout.translated[locale]
            : routineWorkout.workoutTitle;

    final currentProgress =
        miniplayerIndex.currentIndex / miniplayerIndex.routineLength * 100;
    final formattedCurrentProgress = '${f.format(currentProgress)} %';

    return Container(
      width: size.width,
      height: size.height,
      color: kBottomNavBarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.expand_more_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => _closeModalBottomSheet(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          S.current.endMiniplayerButtonText,
                          style: kButtonText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: Center(
                    child: Text(
                      '${routine.routineTitle}',
                      style: kBodyText2w900,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _timerCoverOrEmptyContainer(context, watch),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 4,
            ),
            child: Text(setTitle, style: kHeadline5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${routineWorkout.index}.  ',
                  style: kHeadline6Grey,
                ),
                Text(title, style: kHeadline6Grey),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: LinearProgressIndicatorWidget(
              width: size.width - 48,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  formattedCurrentProgress,
                  style: kBodyText2,
                ),
                Spacer(),
                Text(
                  '100 %',
                  style: kBodyText2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildWorkoutController(context, watch),
          SaveAndExitButton(
            database: database,
            user: user,
          ),
        ],
      ),
    );
  }

  Widget _timerCoverOrEmptyContainer(BuildContext context, ScopedReader watch) {
    final workoutSet = watch(currentWorkoutSetProvider).state;
    final size = MediaQuery.of(context).size;

    final double ratio = size.height / size.width;

    if (workoutSet != null) {
      if (workoutSet.isRest) {
        return RestTimerWidget();
      } else {
        return WeightsAndRepsWidget(
          height: (ratio > 2.00) ? size.width - 56 : size.width - 88,
          width: (ratio > 2.00) ? size.width - 56 : size.width - 88,
        );
      }
    } else {
      return EmptyWorkoutSetWidget();
    }
  }

  Widget _buildWorkoutController(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final workoutSet = watch(currentWorkoutSetProvider).state;

    if (workoutSet != null) {
      return ButtonTheme(
        padding: EdgeInsets.all(0),
        minWidth: size.width / 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            PreviousWorkoutButton(),
            PreviousWorkoutSetButton(),
            PauseOrPlayButton(),
            NextWorkoutSetButton(),
            NextWRoutineorkoutButton(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Future<bool?> _closeModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      // TODO: make translation here
      message: Text('End Workout?'),
      title: Text(
        S.current.endWorkoutWarningMessage,
        textAlign: TextAlign.center,
      ),
      firstActionText: S.current.stopTheWorkout,
      isFirstActionDefault: false,
      firstActionOnPressed: () {
        Navigator.of(context).pop();
        context.read(selectedRoutineProvider).state = null;
        context.read(selectedRoutineWorkoutsProvider).state = null;
        context.read(currentRoutineWorkoutProvider).state = null;
        context.read(currentWorkoutSetProvider).state = null;
        context.read(restTimerDurationProvider).state = null;
      },
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }
}
