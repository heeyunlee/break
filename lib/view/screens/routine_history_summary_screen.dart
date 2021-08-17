import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class RoutineHistorySummaryScreen extends StatefulWidget {
  final RoutineHistory routineHistory;
  final Database database;

  const RoutineHistorySummaryScreen({
    Key? key,
    required this.routineHistory,
    required this.database,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required RoutineHistory routineHistory,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => RoutineHistorySummaryScreen(
          routineHistory: routineHistory,
          database: database,
        ),
      ),
    );
  }

  @override
  _RoutineHistorySummaryScreenState createState() =>
      _RoutineHistorySummaryScreenState();
}

class _RoutineHistorySummaryScreenState
    extends State<RoutineHistorySummaryScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;

  bool _isPublic = true;
  num? _effort = 3;

  late String _title = widget.routineHistory.routineTitle;
  late List<dynamic> _musclesAndEquipment;

  late String _formattedUnit;
  late String _formattedWeight;
  late String _formattedDuration;

  // Notes
  String? get _notes => _textController1.text;
  late TextEditingController _textController1;
  late FocusNode focusNode1;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    _textController1 = TextEditingController();

    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    _textController1.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _update() async {
    try {
      final routineHistory = {
        'isPublic': _isPublic,
        'notes': _notes,
        'effort': _effort,
      };
      await widget.database.updateRoutineHistory(
        widget.routineHistory,
        routineHistory,
      );

      await HapticFeedback.mediumImpact();
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  void dataFormat(RoutineHistory routineHistory) {
    _title = routineHistory.routineTitle;

    _musclesAndEquipment = Formatter.getListOfEquipments(
          routineHistory.equipmentRequired,
          routineHistory.equipmentRequiredEnum,
        ) +
        Formatter.getListOfMainMuscleGroup(
          routineHistory.mainMuscleGroup,
          routineHistory.mainMuscleGroupEnum,
        );

    // Unit Of Mass
    _formattedUnit = Formatter.unitOfMass(
      routineHistory.unitOfMass,
      routineHistory.unitOfMassEnum,
    );

    // Number Formatting
    final _weights = routineHistory.totalWeights;
    _formattedWeight = Formatter.numWithOrWithoutDecimal(_weights);

    // Date / Time
    final startTime = routineHistory.workoutStartTime;
    final formattedStartTime = Formatter.timeInHM(startTime);
    final endTime = routineHistory.workoutEndTime;
    final formattedEndTime = Formatter.timeInHM(endTime);

    _formattedDuration = '$formattedStartTime ~ $formattedEndTime';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    dataFormat(widget.routineHistory);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            _update();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: size.height * 2 / 7,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: widget.routineHistory.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -0.75),
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              kBackgroundColor,
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
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            S.current.stats,
                            maxLines: 1,
                            style: TextStyles.headline6_w900,
                          ),
                        ),
                        SizedBox(height: size.height * 0.018),
                        _SummaryRowWidget(
                          title: '$_formattedWeight ',
                          subtitle: _formattedUnit,
                          imageUrl:
                              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
                        ),
                        SizedBox(height: size.height * 0.018),
                        _SummaryRowWidget(
                          title: _formattedDuration,
                          imageUrl:
                              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            S.current.notes,
                            style: TextStyles.headline6_w900,
                          ),
                        ),
                        Card(
                          color: kCardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: _textController1,
                              style: TextStyles.body2,
                              focusNode: focusNode1,
                              decoration: InputDecoration(
                                hintText: S.current.addNotesHintText,
                                hintStyle: TextStyles.body2_grey,
                                border: InputBorder.none,
                              ),
                              onFieldSubmitted: (value) => setState(() {}),
                              onChanged: (value) => setState(() {}),
                              onSaved: (value) => setState(() {}),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            S.current.setEffortsTitle,
                            style: TextStyles.headline6_w900,
                          ),
                        ),
                        Card(
                          color: kCardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: SizedBox(
                              height: size.height * 0.08,
                              child: Center(
                                child: RatingBar(
                                  initialRating: 3,
                                  glow: false,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                  onRatingUpdate: (rating) {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      _effort = rating;
                                    });
                                  },
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
                              style: TextStyles.body2_light,
                            ),
                            SizedBox(
                              width: 72,
                              child: Text(
                                (_isPublic)
                                    ? S.current.everyone
                                    : S.current.justMe,
                                style: TextStyles.body2_w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              (_isPublic)
                                  ? Icons.public_rounded
                                  : Icons.public_off_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: _isPublic,
                              activeColor: kPrimaryColor,
                              onChanged: (bool value) {
                                HapticFeedback.mediumImpact();
                                setState(() {
                                  _isPublic = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Spacer(),
                        // const SizedBox(height: 40),
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
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                displayTarget: true,
                numberOfParticles: 30,
                blastDirection: -pi / 2,
                colors: [
                  kPrimaryColor,
                  Colors.green,
                  Colors.cyanAccent,
                  Colors.purpleAccent,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            S.current.todaysWorkoutSummary,
            style: TextStyles.subtitle1_grey,
          ),
          Text(
            _title,
            maxLines: 1,
            style: TextStyles.headline5_bold,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: List.generate(
                _musclesAndEquipment.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    label: Text(
                      _musclesAndEquipment[index],
                      style: TextStyles.button1,
                    ),
                    backgroundColor: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: 36,
          height: 36,
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
    );
  }
}
