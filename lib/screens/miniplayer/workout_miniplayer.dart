import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/miniplayer/widgets/empty_workout_set_widget.dart';
import 'package:workout_player/screens/miniplayer/widgets/expanded_miniplayer_title.dart';
import 'package:workout_player/screens/miniplayer/widgets/next_routine_workout_button.dart';
import 'package:workout_player/screens/miniplayer/widgets/pause_or_play_button.dart';
import 'package:workout_player/screens/miniplayer/widgets/rest_timer_widget.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../styles/constants.dart';
import 'widgets/close_miniplayer_button.dart';
import 'widgets/collapsed_miniplayer_title.dart';
import 'widgets/linear_progress_indicator_widget.dart';
import 'widgets/miniplayer_subtitle.dart';
import 'widgets/weights_and_reps_widget.dart';
import 'widgets/next_workout_set_button.dart';
import 'widgets/previous_workout_button.dart';
import 'widgets/previous_workout_set_button.dart';
import 'widgets/save_and_exit_button.dart';
import 'miniplayer_model.dart';

class WorkoutMiniplayer extends ConsumerWidget {
  final Database database;
  final Future<User?> user;

  WorkoutMiniplayer({
    required this.database,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('miniplayer building...');

    final size = MediaQuery.of(context).size;

    final model = ref.watch(miniplayerModelProvider);
    final routine = model.selectedRoutine;

    return Miniplayer(
      controller: model.miniplayerController,
      minHeight: miniplayerMinHeight,
      maxHeight: size.height,
      backgroundColor: Colors.transparent,
      valueNotifier: miniplayerExpandProgress,
      elevation: 6,
      builder: (height, percentage) {
        // debugPrint('height $height, and percentage is $percentage');

        if (routine == null) {
          return const SizedBox.shrink();
        }

        return Container(
          color: kBottomNavBarColor,
          width: size.width,
          height: miniplayerMinHeight,
          child: Stack(
            children: [
              _expandedPlayer(context, percentage: percentage, model: model),
              _collapsedPlayer(context, percentage: percentage, model: model),
            ],
          ),
        );
      },
    );
  }

  Widget _collapsedPlayer(
    BuildContext context, {
    required MiniplayerModel model,
    required double percentage,
  }) {
    final size = MediaQuery.of(context).size;

    return Opacity(
      opacity: 1 - math.pow(percentage, 0.25).toDouble(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicatorWidget(
            width: size.width,
            radius: 0.00,
            model: model,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CollapsedMiniplayerTitle(
                    horzPadding: 16,
                    vertPadding: 4,
                    textStyle: kBodyText1Bold,
                    model: model,
                  ),
                  MiniplayerSubtitle(
                    horizontalPadding: 16,
                    textStyle: kBodyText2Grey,
                    model: model,
                  ),
                ],
              ),
              const Spacer(),
              PauseOrPlayButton(iconSize: 36, model: model),
              NextWorkoutSetButton(iconSize: 36, model: model),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expandedPlayer(
    BuildContext context, {
    required MiniplayerModel model,
    required double percentage,
  }) {
    final f = NumberFormat('#,###');
    final size = MediaQuery.of(context).size;

    final routine = model.selectedRoutine;

    final currentProgress = model.currentIndex / model.setsLength * 100;
    final formattedCurrentProgress = '${f.format(currentProgress)} %';

    return Opacity(
      opacity: math.pow(percentage, 2).toDouble(),
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
                    CloseMiniplayerButton(model: model),
                    const SizedBox(width: 8),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: Center(
                    child: Text(
                      '${routine?.routineTitle}',
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
          _timerCoverOrEmptyContainer(context, model),
          const SizedBox(height: 8),
          ExpandedMiniplayerTitle(model: model),
          MiniplayerSubtitle(model: model),
          const SizedBox(height: 16),
          Center(
            child: LinearProgressIndicatorWidget(
              width: size.width - 48,
              model: model,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  formattedCurrentProgress,
                  style: TextStyles.body2,
                ),
                const Spacer(),
                const Text('100 %', style: TextStyles.body2),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildWorkoutController(context, model),
          SaveAndExitButton(database: database, user: user, model: model),
        ],
      ),
    );
  }

  Widget _timerCoverOrEmptyContainer(
      BuildContext context, MiniplayerModel model) {
    final size = MediaQuery.of(context).size;
    final double ratio = size.height / size.width;

    final workoutSet = model.currentWorkoutSet;

    if (workoutSet != null) {
      if (workoutSet.isRest) {
        return RestTimerWidget(model: model);
      } else {
        return WeightsAndRepsWidget(
          height: (ratio > 2.00) ? size.width - 56 : size.width - 88,
          width: (ratio > 2.00) ? size.width - 56 : size.width - 88,
          model: model,
        );
      }
    } else {
      return EmptyWorkoutSetWidget();
    }
  }

  Widget _buildWorkoutController(BuildContext context, MiniplayerModel model) {
    final size = MediaQuery.of(context).size;

    return ButtonTheme(
      padding: EdgeInsets.all(0),
      minWidth: size.width / 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          PreviousWorkoutButton(model: model),
          PreviousWorkoutSetButton(model: model),
          PauseOrPlayButton(model: model),
          NextWorkoutSetButton(model: model),
          NextWRoutineorkoutButton(model: model),
        ],
      ),
    );
  }
}
