import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/styles/constants.dart';

class NewRoutineDifficultyAndMoreScreen extends StatefulWidget {
  final DoubleCallback ratingCallback;
  final StringCallback locationCallback;

  const NewRoutineDifficultyAndMoreScreen({
    Key? key,
    required this.ratingCallback,
    required this.locationCallback,
  }) : super(key: key);

  @override
  _NewRoutineDifficultyAndMoreScreenState createState() =>
      _NewRoutineDifficultyAndMoreScreenState();
}

class _NewRoutineDifficultyAndMoreScreenState
    extends State<NewRoutineDifficultyAndMoreScreen> {
  double _rating = 0;
  late String _ratingLabel;

  String _dropdownValue = 'Location.gym';

  @override
  void initState() {
    _ratingLabel = Difficulty.values[_rating.toInt()].translation!;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(S.current.location, style: kHeadline6Bold),
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
                  style: kBodyText1,
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

            /// Difficulty
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${S.current.difficulty}: $_ratingLabel',
                style: kHeadline6Bold,
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
                value: _rating,
                onChanged: (newRating) {
                  setState(() {
                    _rating = newRating;
                    _ratingLabel =
                        Difficulty.values[_rating.toInt()].translation!;
                    widget.ratingCallback(_rating);
                  });
                },
                label: '$_ratingLabel',
                min: 0,
                max: 2,
                divisions: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}