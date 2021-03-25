import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';

import '../../../../constants.dart';

typedef StringCallback = void Function(String discription);
typedef DoubleCallback = void Function(double number);

class NewWorkoutDifficultyAndMoreScreen extends StatefulWidget {
  final StringCallback discriptionCallBack;
  final DoubleCallback difficultyCallback;
  final DoubleCallback secondsPerRepCallback;

  const NewWorkoutDifficultyAndMoreScreen({
    Key key,
    this.discriptionCallBack,
    this.difficultyCallback,
    this.secondsPerRepCallback,
  }) : super(key: key);

  @override
  _NewWorkoutDifficultyAndMoreScreenState createState() =>
      _NewWorkoutDifficultyAndMoreScreenState();
}

class _NewWorkoutDifficultyAndMoreScreenState
    extends State<NewWorkoutDifficultyAndMoreScreen> {
  String _description;
  var _textController = TextEditingController();

  double _difficultySlider;
  String _difficultySliderLabel;

  double _secondsPerRepSlider;
  String _secondsPerRepSliderLabel;

  @override
  void initState() {
    super.initState();
    _description = null;
    _textController = TextEditingController(text: _description);

    _difficultySlider = 0;
    _difficultySliderLabel = Difficulty.values[_difficultySlider.toInt()].label;

    _secondsPerRepSlider = 2;
    _secondsPerRepSliderLabel = '$_secondsPerRepSlider ${S.current.seconds}';
    debugPrint('NewWorkoutDifficultyAndMoreScreen init');
  }

  @override
  void dispose() {
    _textController.dispose();
    debugPrint('NewWorkoutDifficultyAndMoreScreen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('NewWorkoutDifficultyAndMoreScreen scaffold building...');

    final size = MediaQuery.of(context).size;
    final f = NumberFormat('#,###');
    final formattedSecondsPerRep = f.format(_secondsPerRepSlider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.description, style: BodyText1w800),
                ),
                Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _textController,
                      style: BodyText2,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: S.current.descriptionHintText,
                        hintStyle: BodyText2LightGrey,
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (value) {
                        _description = value;
                        widget.discriptionCallBack(_description);
                      },
                      onChanged: (value) {
                        _description = value;
                        widget.discriptionCallBack(_description);
                      },
                      onSaved: (value) {
                        _description = value;
                        widget.discriptionCallBack(_description);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Difficulty
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${S.current.workoutDifficultySliderText}: $_difficultySliderLabel',
                    style: BodyText1w800,
                  ),
                ),
                Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slider(
                    activeColor: PrimaryColor,
                    inactiveColor: PrimaryColor.withOpacity(0.2),
                    value: _difficultySlider,
                    onChanged: (newRating) {
                      setState(() {
                        _difficultySlider = newRating;
                        widget.difficultyCallback(_difficultySlider);

                        _difficultySliderLabel =
                            Difficulty.values[_difficultySlider.toInt()].label;
                      });
                    },
                    label: '$_difficultySliderLabel',
                    min: 0,
                    max: 2,
                    divisions: 2,
                  ),
                ),
                const SizedBox(height: 36),

                // Seconds per Rep
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${S.current.secondsPerRep}: $formattedSecondsPerRep ${S.current.seconds}',
                    style: BodyText1w800,
                  ),
                ),
                Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slider(
                    activeColor: PrimaryColor,
                    inactiveColor: PrimaryColor.withOpacity(0.2),
                    value: _secondsPerRepSlider,
                    onChanged: (newRating) {
                      setState(() {
                        _secondsPerRepSlider = newRating;
                        widget.secondsPerRepCallback(_secondsPerRepSlider);

                        _secondsPerRepSliderLabel =
                            '$formattedSecondsPerRep ${S.current.seconds}';
                      });
                    },
                    label: _secondsPerRepSliderLabel,
                    min: 1,
                    max: 10,
                    // divisions: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.current.secondsPerRepHelperText,
                    style: Caption1Grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
