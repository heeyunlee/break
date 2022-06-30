import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/workout_summary_screen_model.dart';
import 'package:workout_player/widgets/widgets.dart';

class WorkoutSummaryScreen extends StatefulWidget {
  const WorkoutSummaryScreen({
    Key? key,
    required this.routineHistory,
    required this.model,
  }) : super(key: key);

  final RoutineHistory routineHistory;
  final WorkoutSummaryScreenModel model;

  static void show(
    BuildContext context, {
    required RoutineHistory routineHistory,
  }) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) => WorkoutSummaryScreen(
          routineHistory: routineHistory,
          model: ref.watch(workoutSummaryScreenModelProvider),
        ),
      ),
    );
  }

  @override
  State<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
  @override
  void initState() {
    super.initState();

    widget.model.init(widget.routineHistory);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppBarCloseButton(
          onPressed: () async {
            final status = await widget.model.update(widget.routineHistory);

            if (!mounted) return;

            if (status.statusCode == 200) {
              Navigator.of(context).pop();
            } else {
              await showExceptionAlertDialog(
                context,
                title: S.current.operationFailed,
                exception: e.toString(),
              );
            }
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Form _buildBody() {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Form(
      key: WorkoutSummaryScreenModel.formKey,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: size.height * 2 / 7,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      AdaptiveCachedNetworkImage(
                        imageUrl: widget.routineHistory.imageUrl,
                        fit: BoxFit.cover,
                        errorWidgetBuilder: (_, __, ___) =>
                            const Icon(Icons.error),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.0, -0.75),
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              theme.backgroundColor,
                            ],
                          ),
                        ),
                      ),
                      _buildChips(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: size.height * 5 / 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildStats(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            S.current.notes,
                            style: TextStyles.headline6W900,
                          ),
                        ),
                        OutlinedTextTextFieldWidget(
                          focusNode: widget.model.focusNode,
                          controller: widget.model.textEditingController,
                          formKey: WorkoutSummaryScreenModel.formKey,
                          hintText: S.current.addNotesHintText,
                          textInputAction: TextInputAction.done,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            S.current.setEffortsTitle,
                            style: TextStyles.headline6W900,
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: SizedBox(
                              height: size.height * 0.08,
                              child: Center(
                                child: RatingBar(
                                  initialRating: widget.model.effort.toDouble(),
                                  glow: false,
                                  allowHalfRating: true,
                                  // itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  ratingWidget: RatingWidget(
                                    empty: Image.asset(
                                      'assets/emojis/fire_none.png',
                                    ),
                                    full: Image.asset(
                                      'assets/emojis/fire_full.png',
                                    ),
                                    half: Image.asset(
                                      'assets/emojis/fire_half.png',
                                    ),
                                  ),
                                  onRatingUpdate: widget.model.onRatingUpdate,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              S.current.makeItVisibleTo,
                              style: TextStyles.body2Light,
                            ),
                            SizedBox(
                              width: 72,
                              child: Text(
                                (widget.model.isPublic)
                                    ? S.current.everyone
                                    : S.current.justMe,
                                style: TextStyles.body2W900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              (widget.model.isPublic)
                                  ? Icons.public_rounded
                                  : Icons.public_off_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: widget.model.isPublic,
                              activeColor: theme.primaryColor,
                              onChanged: widget.model.isPublicOnChanged,
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: ConfettiWidget(
                maxBlastForce: 100,
                maximumSize: const Size(10, 10),
                minimumSize: const Size(5, 5),
                confettiController: widget.model.confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                displayTarget: true,
                numberOfParticles: 30,
                blastDirection: -pi / 2,
                colors: [
                  theme.primaryColor,
                  theme.colorScheme.secondary,
                  Colors.red,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips() {
    final theme = Theme.of(context);

    final musclesAndEquipments = Formatter.getListOfEquipments(
          widget.routineHistory.equipmentRequired,
          widget.routineHistory.equipmentRequiredEnum,
        ) +
        Formatter.getListOfMainMuscleGroup(
          widget.routineHistory.mainMuscleGroup,
          widget.routineHistory.mainMuscleGroupEnum,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            S.current.todaysWorkoutSummary,
            style: TextStyles.subtitle1Grey,
          ),
          Text(
            widget.routineHistory.routineTitle,
            maxLines: 1,
            style: TextStyles.headline5Bold,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: List.generate(
                musclesAndEquipments.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    label: Text(
                      musclesAndEquipments[index],
                      style: TextStyles.button1,
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(S.current.stats, style: TextStyles.headline6W900),
        ),
        if (widget.routineHistory.routineHistoryType == 'routine')
          _SummaryRowWidget(
            title:
                '${Formatter.numWithOrWithoutDecimal(widget.routineHistory.totalWeights)} ',
            subtitle: Formatter.unitOfMass(
              widget.routineHistory.unitOfMass,
              widget.routineHistory.unitOfMassEnum,
            ),
            imageUrl:
                'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
          ),
        if (widget.routineHistory.routineHistoryType == 'youtube')
          _SummaryRowWidget(
            subtitle: ' Kcal',
            title: Formatter.numWithOrWithoutDecimal(
              widget.routineHistory.totalCalories,
            ),
            imageUrl:
                'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/285/heart-on-fire_2764-fe0f-200d-1f525.png',
          ),
        _SummaryRowWidget(
          title: Formatter.durationInString(
            widget.routineHistory.workoutStartTime,
            widget.routineHistory.workoutEndTime,
          ),
          imageUrl:
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
        ),
      ],
    );
  }
}

class _SummaryRowWidget extends StatelessWidget {
  const _SummaryRowWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AdaptiveCachedNetworkImage(
            imageUrl: imageUrl,
            size: const Size(36, 36),
          ),
          const SizedBox(width: 16),
          RichText(
            text: TextSpan(
              style: TextStyles.headline5,
              children: <TextSpan>[
                TextSpan(text: title),
                if (subtitle != null)
                  TextSpan(
                    text: subtitle,
                    style: TextStyles.subtitle1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
