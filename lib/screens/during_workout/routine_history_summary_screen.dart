import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/services/database.dart';

import '../../format.dart';

class RoutineHistorySummaryScreen extends StatefulWidget {
  final RoutineHistory routineHistory;
  final Database database;

  const RoutineHistorySummaryScreen({
    Key key,
    this.routineHistory,
    this.database,
  }) : super(key: key);

  static void show({
    BuildContext context,
    RoutineHistory routineHistory,
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
  FocusNode focusNode1;
  var _textController1 = TextEditingController();
  ConfettiController _confettiController;

  String _notes;
  bool _isPublic = true;
  double _effort = 3;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    _textController1 = TextEditingController(text: _notes);
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
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Data
    final title = widget.routineHistory?.routineTitle ?? 'Title';
    final mainMuscleGroups = widget.routineHistory.mainMuscleGroup;
    final equipments = widget.routineHistory.equipmentRequired;

    // Unit Of Mass
    final unit = widget.routineHistory.unitOfMass;
    final formattedUnit = Format.unitOfMass(unit);

    // Number Formatting
    final weights = widget.routineHistory.totalWeights;
    final formattedWeight = Format.weights(weights);

    // Date / Time
    final startTime = widget.routineHistory.workoutStartTime;
    final formattedStartTime = Format.timeInHM(startTime);
    final endTime = widget.routineHistory.workoutEndTime;
    final formattedEndTime = Format.timeInHM(endTime);

    final formattedDuration = '$formattedStartTime ~ $formattedEndTime';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
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
                              BackgroundColor,
                            ],
                          ),
                        ),
                      ),
                      // TODO: Polish below code
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              'Today\'s Workout: ',
                              style: Subtitle1Grey,
                            ),
                            Text(
                              title,
                              maxLines: 1,
                              style: Headline5Bold.copyWith(
                                fontSize: size.height * 0.03,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              child: Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      '${mainMuscleGroups[0]}',
                                      style: ButtonText,
                                    ),
                                    backgroundColor: PrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  if (mainMuscleGroups.length > 1)
                                    Chip(
                                      label: Text('${mainMuscleGroups[1]}',
                                          style: ButtonText),
                                      backgroundColor: PrimaryColor,
                                    ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      '${equipments[0]}',
                                      style: ButtonText,
                                    ),
                                    backgroundColor: PrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  if (equipments.length > 1)
                                    Chip(
                                      label: Text('${equipments[1]}',
                                          style: ButtonText),
                                      backgroundColor: PrimaryColor,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            'Stats',
                            maxLines: 1,
                            style: Headline6w900.copyWith(
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.018),
                        _SummaryRowWidget(
                          title: formattedWeight,
                          subtitle: ' $formattedUnit  Lifted',
                          imageUrl:
                              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
                        ),
                        SizedBox(height: size.height * 0.018),
                        _SummaryRowWidget(
                          title: formattedDuration,
                          // subtitle: ' min  Spent',
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
                            'Note',
                            style: Headline6w900.copyWith(
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                        Card(
                          color: CardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              controller: _textController1,
                              style: BodyText2,
                              focusNode: focusNode1,
                              decoration: const InputDecoration(
                                hintText: 'How do you feel? Add Notes',
                                hintStyle: BodyText2Grey,
                                border: InputBorder.none,
                              ),
                              onFieldSubmitted: (value) {
                                _notes = value;
                              },
                              onChanged: (value) => _notes = value,
                              onSaved: (value) => _notes = value,
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
                            'How was your workout?',
                            style: Headline6w900.copyWith(
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                        Card(
                          color: CardColor,
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
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Make it visible to:    ',
                              style: BodyText2Light,
                            ),
                            SizedBox(
                              width: 72,
                              child: Text(
                                (_isPublic) ? 'Everyone' : 'Just Me',
                                style: BodyText2w900,
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
                              activeColor: PrimaryColor,
                              onChanged: (bool value) {
                                HapticFeedback.mediumImpact();
                                setState(() {
                                  _isPublic = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
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
                  PrimaryColor,
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
}

class _SummaryRowWidget extends StatelessWidget {
  const _SummaryRowWidget({
    Key key,
    this.imageUrl,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            style: Headline5.copyWith(fontSize: size.height * 0.03),
            children: <TextSpan>[
              TextSpan(text: title),
              if (subtitle != null) TextSpan(text: subtitle, style: Subtitle1)
            ],
          ),
        ),
      ],
    );
  }
}
