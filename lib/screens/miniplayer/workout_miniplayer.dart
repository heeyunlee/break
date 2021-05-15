import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/miniplayer/widgets/next_routine_workout_button.dart';
import 'package:workout_player/screens/miniplayer/widgets/pause_or_play_button.dart';
import 'package:workout_player/screens/miniplayer/widgets/rest_timer_widget.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/empty_content.dart';

import '../../constants.dart';
import 'widgets/weights_and_reps_widget.dart';
import 'widgets/next_workout_set_button.dart';
import 'widgets/previous_workout_button.dart';
import 'widgets/previous_workout_set_button.dart';
import 'widgets/save_and_exit_button.dart';
import 'workout_miniplayer_provider.dart';

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
    final isWorkoutPaused = watch(isWorkoutPausedProvider);
    final routineWorkouts = watch(selectedRoutineWorkoutsProvider).state;
    final miniplayerIndex = watch(miniplayerIndexProvider);

    return Miniplayer(
      controller: miniplayerController,
      minHeight: miniplayerMinHeight,
      maxHeight: size.height,
      backgroundColor: Colors.transparent,
      elevation: 6,
      builder: (height, percentage) {
        debugPrint('height $height, and percentage is $percentage');

        if (routine == null) {
          return const SizedBox.shrink();
        }

        if (percentage == 0) {
          return _collapsedPlayer(
            routine: routine,
            routineWorkouts: routineWorkouts,
            isWorkoutPaused: isWorkoutPaused,
            currentIndex: miniplayerIndex,
            // countdownController: countdownController,
          );
        }

        return _expandedPlayer(context, watch);
      },
    );
  }

  Widget _collapsedPlayer({
    required Routine routine,
    List<RoutineWorkout>? routineWorkouts,
    required IsWorkoutPausedNotifier isWorkoutPaused,
    required MiniplayerIndexNotifier currentIndex,
    // required CountDownController counstdownController,
  }) {
    return Container(
      color: kBackgroundColor,
      child: Text('Collapsed', style: kBodyText1),
    );
  }

  Widget _expandedPlayer(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final routine = watch(selectedRoutineProvider).state!;

    return Container(
      width: size.width,
      height: size.height,
      color: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
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
                        onPressed: () {
                          context.read(selectedRoutineProvider).state = null;
                          context.read(selectedRoutineWorkoutsProvider).state =
                              null;
                          context.read(currentRoutineWorkoutProvider).state =
                              null;
                          context.read(currentWorkoutSetProvider).state = null;
                          context.read(restTimerDurationProvider).state = null;
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text('CLOSE', style: kButtonText),
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
          ..._buildBody(context, watch),
        ],
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     brightness: Brightness.dark,
    //     backgroundColor: Colors.transparent,
    //     centerTitle: true,
    //     elevation: 0,
    //     title: Text('${routine.routineTitle}', style: kBodyText2w900),
    //     leading: Padding(
    //       padding: const EdgeInsets.only(left: 8),
    //       child: const Icon(Icons.expand_more_rounded, size: 32),
    //     ),
    //   ),
    //   extendBodyBehindAppBar: true,
    //   backgroundColor: kBackgroundColor,
    //   body: _buildBody(context, watch),
    // );
  }

  List<Widget> _buildBody(BuildContext context, ScopedReader watch) {
    final workoutSet = watch(currentWorkoutSetProvider).state;

    if (workoutSet != null) {
      return _buildStreamBody(context, watch);
    } else {
      return [
        EmptyContent(
          message: S.current.addSetsToWorkout,
        ),
      ];
    }
  }

  List<Widget> _buildStreamBody(BuildContext context, ScopedReader watch) {
    final f = NumberFormat('#,###');
    final size = MediaQuery.of(context).size;
    final locale = Intl.getCurrentLocale();

    final miniplayerIndex = watch(miniplayerIndexProvider);
    final routineWorkout = watch(currentRoutineWorkoutProvider).state!;
    final workoutSet = watch(currentWorkoutSetProvider).state;

    final currentProgress =
        miniplayerIndex.currentIndex / miniplayerIndex.routineLength * 100;
    final formattedCurrentProgress = '${f.format(currentProgress)} %';

    final setTitle = (workoutSet!.isRest)
        ? S.current.rest
        : '${S.current.set} ${workoutSet.setIndex}';

    final translation = routineWorkout.translated;
    final title = (translation.isEmpty)
        ? routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? routineWorkout.translated[locale]
            : routineWorkout.workoutTitle;

    return [
      (!workoutSet.isRest) ? WeightsAndRepsWidget() : RestTimerWidget(),
      SizedBox(height: size.height * 0.03),
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
              style: kHeadline6Grey.copyWith(
                fontSize: size.height * 0.02,
              ),
            ),
            Text(title, style: kHeadline6Grey),
          ],
        ),
      ),
      SizedBox(height: size.height * 0.02),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                color: Colors.grey[800],
                height: 4,
                width: size.width - 48,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                color: kPrimaryColor,
                height: 4,
                width: (size.width - 48) *
                    miniplayerIndex.currentIndex /
                    miniplayerIndex.routineLength,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            Text(
              formattedCurrentProgress,
              style: kBodyText2.copyWith(fontSize: size.height * 0.017),
            ),
            Spacer(),
            Text(
              '100 %',
              style: kBodyText2.copyWith(fontSize: size.height * 0.017),
            ),
          ],
        ),
      ),
      SizedBox(height: size.height * 0.01),
      ButtonTheme(
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
      ),
      // Spacer(),
      SaveAndExitButton(
        database: database,
        user: user,
      ),
    ];
  }
}
