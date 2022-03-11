import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class MiniplayerScreen extends ConsumerWidget {
  const MiniplayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch<Database>(databaseProvider);

    logger.d('[MiniplayerScreen] building...');

    return CustomStreamBuilder<User?>(
      stream: database.userStream(),
      loadingWidget: const SizedBox.shrink(),
      builder: (context, user) => Consumer(
        builder: (context, ref, child) {
          final size = MediaQuery.of(context).size;
          final model = ref.watch(miniplayerModelProvider);
          final homeModel = ref.watch(homeScreenModelProvider);

          return Offstage(
            offstage: model.currentWorkout == null,
            child: Miniplayer(
              duration: const Duration(milliseconds: 500),
              controller: model.miniplayerController,
              minHeight: homeModel.miniplayerMinHeight!,
              maxHeight: size.height,
              valueNotifier: homeModel.valueNotifier,
              elevation: 6,
              builder: (height, percentage) {
                if (model.currentWorkout == null) {
                  return const SizedBox.shrink();
                } else {
                  if (model.currentWorkout.runtimeType == Routine) {
                    return _buildMiniplayer(context, percentage, model, user!);
                  }
                  return Container();
                  // return YoutubePlayerControllerProvider(
                  //   controller: model.youtubeController!,
                  //   child: _buildMiniplayer(context, percentage, model, user!),
                  // );
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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final aspectRatio = ui.window.physicalSize.aspectRatio;
    final isScreenBigger = aspectRatio < 0.5;

    return Container(
      color: theme.bottomNavigationBarTheme.backgroundColor,
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
            height: isScreenBigger ? 96 : 64,
            widget: _buildCustomAppBar(context),
          ),
          _opacitySizeBuilder(
            percentage: percentage,
            height: isScreenBigger ? 24.0 : 16.0,
            widget: SizedBox(height: isScreenBigger ? 24.0 : 16.0),
          ),
          _buildMainWidget(context, percentage, model),
          _opacitySizeBuilder(
            percentage: percentage,
            height: isScreenBigger ? 24.0 : 16.0,
            widget: SizedBox(height: isScreenBigger ? 24.0 : 16.0),
          ),
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
    final theme = Theme.of(context);

    final isScreenBigger = size.height > 700;
    final paddingFactor = isScreenBigger ? 56 : 104;

    if (model.currentWorkout.runtimeType == Routine) {
      final workoutSet = model.currentWorkoutSet;

      final widget = (workoutSet == null)
          ? const EmptyWorkoutSetWidget()
          : (workoutSet.isRest)
              ? RestTimerWidget(model: model)
              : WeightsAndRepsWidget(model: model);

      return Stack(
        children: [
          _opacitySizeBuilder(
            percentage: percentage,
            width: size.width - paddingFactor,
            height: size.width - paddingFactor,
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
              Offstage(
                offstage: percentage > 0.5,
                child: _opacitySizeBuilder(
                  reversed: true,
                  percentage: percentage,
                  widget: Container(
                    color: theme.backgroundColor.withOpacity(0.9),
                    child: _collapedWidget(context, model),
                  ),
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
        ? const Interval(0.85, 1.00, curve: Curves.easeOut)
            .transform(1 - percentage)
        : const Interval(0.25, 0.50, curve: Curves.easeOut)
            .transform(percentage);

    final intervalB = reversed
        ? const Interval(0.85, 1.00, curve: Curves.easeIn)
            .transform(1 - percentage)
        : const Interval(0.00, 0.25, curve: Curves.easeIn)
            .transform(percentage);

    return Opacity(
      opacity: intervalA,
      child: SizedBox(
        width: (width != null) ? width * intervalB : null,
        height: (height != null) ? height * intervalB : null,
        child: widget,
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isScreenBigger = size.height > 700;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isScreenBigger ? 48 : 24,
      ),
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
                  // vertPadding: 4,
                  textStyle: TextStyles.body1Bold,
                ),
                MiniplayerSubtitle(
                  horizontalPadding: 16,
                  textStyle: TextStyles.body2Grey,
                  model: model,
                ),
              ],
            ),
          ),
        ),
        PauseOrPlayButton(iconSize: 36, model: model),
        const NextWorkoutSetButton(iconSize: 36),
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
