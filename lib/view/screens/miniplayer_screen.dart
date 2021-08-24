import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/models/models.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class MiniplayerScreen extends StatelessWidget {
  const MiniplayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[MiniplayerScreen] building...');

    final database = provider.Provider.of<Database>(context, listen: false);

    return CustomStreamBuilder<User?>(
      stream: database.userStream(),
      builder: (context, user) => Consumer(
        builder: (context, watch, child) {
          final size = MediaQuery.of(context).size;
          final model = watch(miniplayerModelProvider);

          return Offstage(
            offstage: model.currentWorkout == null,
            child: Miniplayer(
              duration: const Duration(milliseconds: 500),
              controller: model.miniplayerController,
              minHeight: miniplayerMinHeight,
              maxHeight: size.height,
              valueNotifier: model.valueNotifier,
              elevation: 6,
              builder: (height, percentage) {
                if (model.currentWorkout == null) {
                  return const SizedBox.shrink();
                } else {
                  if (model.currentWorkout.runtimeType == Routine) {
                    return _buildMiniplayer(context, percentage, model, user!);
                  }
                  return YoutubePlayerControllerProvider(
                    controller: model.youtubeController!,
                    child: _buildMiniplayer(context, percentage, model, user!),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniplayer(
    BuildContext context,
    double percentage,
    MiniplayerModel model,
    User user,
  ) {
    logger.d('_buildMiniplayer() called...');

    final size = MediaQuery.of(context).size;

    return Container(
      color: kBottomNavBarColor,
      child: Column(
        children: [
          _opacitySizeBuilder(
            percentage: percentage,
            reversed: true,
            height: 4,
            widget: MiniplayerProgressIndicator(
              model: model,
              radius: 0,
              isExpanded: false,
            ),
          ),
          _opacitySizeBuilder(
            percentage: percentage,
            width: size.width,
            height: 96,
            widget: _buildCustomAppBar(),
          ),
          _buildMainWidget(context, percentage, model),
          _opacitySizeBuilder(
            percentage: percentage,
            widget: _buildExpandedMiniplayerController(context, model, user),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWidget(
    BuildContext context,
    double percentage,
    MiniplayerModel model,
  ) {
    final size = MediaQuery.of(context).size;

    if (model.currentWorkout.runtimeType == Routine) {
      final workoutSet = model.currentWorkoutSet;

      final widget = (workoutSet == null)
          ? EmptyWorkoutSetWidget()
          : (workoutSet.isRest)
              ? RestTimerWidget(model: model)
              : WeightsAndRepsWidget(model: model);

      return Row(
        children: [
          _opacitySizeBuilder(
            percentage: percentage,
            width: size.width,
            height: size.width,
            widget: widget,
          ),
          _opacitySizeBuilder(
            reversed: true,
            width: size.width,
            percentage: percentage,
            widget: _collapedWidget(context, model),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 40 * percentage),
          Stack(
            children: [
              const YoutubePlayerWidget(),
              _opacitySizeBuilder(
                reversed: true,
                percentage: percentage,
                widget: Container(
                  color: kBottomNavBarColor.withOpacity(0.9),
                  child: _collapedWidget(context, model),
                ),
              ),
            ],
          ),
          SizedBox(height: 40 * percentage),
        ],
      );
    }
  }

  Widget _opacitySizeBuilder({
    required double percentage,
    double? width,
    double? height,
    required Widget widget,
    bool? reversed = false,
  }) {
    final intervalA = reversed!
        ? Interval(0.85, 1.00, curve: Curves.easeOut).transform(1 - percentage)
        : Interval(0.25, 0.50, curve: Curves.easeOut).transform(percentage);

    final intervalB = reversed
        ? Interval(0.85, 1.00, curve: Curves.easeIn).transform(1 - percentage)
        : Interval(0.00, 0.25, curve: Curves.easeIn).transform(percentage);

    return Opacity(
      opacity: intervalA,
      child: SizedBox(
        width: (width != null) ? width * intervalB : null,
        height: (height != null) ? height * intervalB : null,
        child: widget,
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: const [
              SizedBox(width: 8),
              Icon(
                Icons.expand_more_rounded,
                size: 32,
                color: Colors.white,
              ),
              Spacer(),
              CloseMiniplayerButton(),
              SizedBox(width: 8),
            ],
          ),
          const AppBarTitleWidget(),
        ],
      ),
    );
  }

  Widget _collapedWidget(BuildContext context, MiniplayerModel model) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SizedBox(
          height: 60,
          width: size.width - 112,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiniplayerTitle(
                  model: model,
                  isExpanded: false,
                  horzPadding: 16,
                  vertPadding: 4,
                  textStyle: TextStyles.body1_bold,
                ),
                MiniplayerSubtitle(
                  horizontalPadding: 16,
                  textStyle: TextStyles.body2_grey,
                  model: model,
                ),
              ],
            ),
          ),
        ),
        PauseOrPlayButton(iconSize: 36, model: model),
        NextWorkoutSetButton(iconSize: 36),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildExpandedMiniplayerController(
    BuildContext context,
    MiniplayerModel model,
    User user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MiniplayerTitle(model: model, isExpanded: true),
        MiniplayerSubtitle(model: model),
        const SizedBox(height: 16),
        MiniplayerProgressIndicator(
          padding: 24,
          model: model,
          isExpanded: true,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const PreviousWorkoutButton(),
            const PreviousWorkoutSetButton(),
            PauseOrPlayButton(model: model),
            const NextWorkoutSetButton(),
            const NextWRoutineorkoutButton(),
          ],
        ),
        if (model.isWorkoutPaused) SaveAndExitButton(user: user),
      ],
    );
  }
}
