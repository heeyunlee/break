import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class WorkoutMiniplayer extends ConsumerWidget {
  final Database database;
  final AuthBase auth;

  const WorkoutMiniplayer({
    Key? key,
    required this.database,
    required this.auth,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return WorkoutMiniplayer(auth: auth, database: database);
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    logger.d('miniplayer building...');

    final size = MediaQuery.of(context).size;

    final model = watch(miniplayerModelProvider);
    final routine = model.selectedRoutine;

    return Offstage(
      offstage: model.selectedRoutine == null,
      child: Miniplayer(
        controller: model.miniplayerController,
        minHeight: miniplayerMinHeight,
        maxHeight: size.height,
        backgroundColor: Colors.transparent,
        valueNotifier: miniplayerExpandProgress,
        elevation: 6,
        builder: (height, percentage) {
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
      ),
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
                    textStyle: TextStyles.body1_bold,
                    model: model,
                  ),
                  MiniplayerSubtitle(
                    horizontalPadding: 16,
                    textStyle: TextStyles.body2_grey,
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
                      style: TextStyles.body2_w900,
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
          SaveAndExitButton(database: database, model: model, auth: auth),
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