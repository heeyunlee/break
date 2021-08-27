import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class NewWorkoutDifficultyAndMoreScreen extends StatefulWidget {
  final StringCallback discriptionCallback;
  final DoubleCallback difficultyCallback;
  final DoubleCallback secondsPerRepCallback;
  final StringCallback locationCallback;

  const NewWorkoutDifficultyAndMoreScreen({
    Key? key,
    required this.discriptionCallback,
    required this.difficultyCallback,
    required this.secondsPerRepCallback,
    required this.locationCallback,
  }) : super(key: key);

  @override
  _NewWorkoutDifficultyAndMoreScreenState createState() =>
      _NewWorkoutDifficultyAndMoreScreenState();
}

class _NewWorkoutDifficultyAndMoreScreenState
    extends State<NewWorkoutDifficultyAndMoreScreen> {
  late String? _description;
  late TextEditingController _textController;

  late double _difficultySlider;
  late String _difficultySliderLabel;

  late double _secondsPerRepSlider;
  late String _secondsPerRepSliderLabel;

  String _dropdownValue = 'Location.gym';

  @override
  void initState() {
    super.initState();
    _description = null;
    _textController = TextEditingController(text: _description);

    _difficultySlider = 0;
    _difficultySliderLabel =
        Difficulty.values[_difficultySlider.toInt()].translation!;

    _secondsPerRepSlider = 3;
    _secondsPerRepSliderLabel = '$_secondsPerRepSlider ${S.current.seconds}';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    S.current.description,
                    style: TextStyles.body1W800,
                  ),
                ),
                Card(
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _textController,
                      style: TextStyles.body2,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: S.current.descriptionHintText,
                        hintStyle: TextStyles.body2LightGrey,
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (value) {
                        _description = value;
                        widget.discriptionCallback(_description!);
                      },
                      onChanged: (value) {
                        _description = value;
                        widget.discriptionCallback(_description!);
                      },
                      onSaved: (value) {
                        _description = value;
                        widget.discriptionCallback(_description!);
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
                    style: TextStyles.body1W800,
                  ),
                ),
                Card(
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slider(
                    activeColor: kPrimaryColor,
                    inactiveColor: kPrimaryColor.withOpacity(0.2),
                    value: _difficultySlider,
                    onChanged: (newRating) {
                      setState(() {
                        _difficultySlider = newRating;
                        widget.difficultyCallback(_difficultySlider);

                        _difficultySliderLabel = Difficulty
                            .values[_difficultySlider.toInt()].translation!;
                      });
                    },
                    label: _difficultySliderLabel,
                    // min: 0,
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
                    style: TextStyles.body1W800,
                  ),
                ),
                Card(
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slider(
                    activeColor: kPrimaryColor,
                    inactiveColor: kPrimaryColor.withOpacity(0.2),
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
                    style: TextStyles.caption1Grey,
                  ),
                ),
                const SizedBox(height: 36),

                /// Location
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        S.current.location,
                        style: TextStyles.headline6Bold,
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: kCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: _dropdownValue,
                      dropdownColor: kCardColor,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                      ),
                      style: TextStyles.body1,
                      onChanged: (value) {
                        setState(() {
                          _dropdownValue = value.toString();
                          widget.locationCallback(value.toString());
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'Location.gym',
                          child: Text(Location.gym.translation!),
                        ),
                        DropdownMenuItem(
                          value: 'Location.atHome',
                          child: Text(Location.atHome.translation!),
                        ),
                        DropdownMenuItem(
                          value: 'Location.outdoor',
                          child: Text(Location.outdoor.translation!),
                        ),
                        DropdownMenuItem(
                          value: 'Location.others',
                          child: Text(Location.others.translation!),
                        ),
                      ],
                    ),
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
