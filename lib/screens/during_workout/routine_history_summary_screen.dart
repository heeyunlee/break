import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/library_tab/activity/routine_history/activity_list_tile.dart';
import 'package:workout_player/screens/library_tab/activity/routine_history/summary_row_widget.dart';
import 'package:workout_player/services/database.dart';

import '../../format.dart';

class RoutineHistorySummaryScreen extends StatefulWidget {
  const RoutineHistorySummaryScreen({Key key, this.routineHistory})
      : super(key: key);

  final RoutineHistory routineHistory;

  static void show({
    BuildContext context,
    RoutineHistory routineHistory,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => RoutineHistorySummaryScreen(
          routineHistory: routineHistory,
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

  String _notes = '';
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    _textController1 = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    focusNode1.dispose();
    _textController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Data
    final title = widget.routineHistory?.routineTitle ?? 'Title';
    final mainMuscleGroup = widget.routineHistory?.mainMuscleGroup ?? 'Null';
    final equipmentRequired =
        widget.routineHistory?.equipmentRequired[0] ?? 'Null';

    final database = Provider.of<Database>(context);

    // Unit Of Mass
    final unit = widget.routineHistory.unitOfMass;
    final formattedUnit = Format.unitOfMass(unit);

    // Number Formatting
    final weights = widget.routineHistory.totalWeights;
    final formattedWeight = Format.weights(weights);

    final duration = widget.routineHistory.totalDuration;
    final formattedDuration = Format.durationInMin(duration);

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
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: size.height / 3,
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
                        begin: Alignment(0.0, -0.5),
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          BackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          'Here is your Workout Summary:',
                          style: Subtitle1Bold,
                        ),
                        Text(
                          title,
                          maxLines: 1,
                          style: Headline4Bold,
                        ),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                '$mainMuscleGroup Workout',
                                style: ButtonText,
                              ),
                              backgroundColor: PrimaryColor,
                            ),
                            const SizedBox(width: 16),
                            Chip(
                              label: Text(equipmentRequired, style: ButtonText),
                              backgroundColor: PrimaryColor,
                            ),
                          ],
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
                height: size.height * 2 / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _SummaryRowWidget(
                      title: formattedWeight,
                      subtitle: ' $formattedUnit  Lifted',
                      imageUrl:
                          'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
                    ),
                    const SizedBox(height: 16),
                    _SummaryRowWidget(
                      title: '$formattedDuration',
                      subtitle: ' min  Spent',
                      imageUrl:
                          'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
                    ),
                    const SizedBox(height: 48),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text('Note', style: Headline6w900),
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
                            // _submit();
                          },
                          onChanged: (value) => _notes = value,
                          onSaved: (value) => _notes = value,
                        ),
                      ),
                    ),
                    // SizedBox(height: 32),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 16,
                    //     vertical: 8,
                    //   ),
                    //   child: Text('I\'m feeling...', style: Headline6w900),
                    // ),
                    // MaterialButton(
                    //   height: 80,
                    //   minWidth: 80,
                    //   color: PrimaryColor.withOpacity(0.8),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   onPressed: () {},
                    //   child: CachedNetworkImage(
                    //     imageUrl:
                    //         'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/sweat-droplets_1f4a6.png',
                    //     width: 36,
                    //     height: 36,
                    //   ),
                    // ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Make it visible to: ', style: BodyText2Light),
                        Text(
                          (_isPublic) ? 'Everyone' : 'Just Me',
                          style: BodyText2w900,
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

                    const SizedBox(height: 56),
                  ],
                ),
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
            style: Headline4,
            children: <TextSpan>[
              TextSpan(text: title),
              TextSpan(text: subtitle, style: Subtitle1)
            ],
          ),
        ),
      ],
    );
  }
}
