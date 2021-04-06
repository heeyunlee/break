import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/models/enum/location.dart';

import '../../../../constants.dart';

typedef DoubleCallback = Function(double rating);
typedef StringCallBack = Function(String location);

class NewRoutineDifficultyAndMoreScreen extends StatefulWidget {
  final DoubleCallback ratingCallback;
  final StringCallBack locationCallback;

  const NewRoutineDifficultyAndMoreScreen({
    Key key,
    this.ratingCallback,
    this.locationCallback,
  }) : super(key: key);

  @override
  _NewRoutineDifficultyAndMoreScreenState createState() =>
      _NewRoutineDifficultyAndMoreScreenState();
}

class _NewRoutineDifficultyAndMoreScreenState
    extends State<NewRoutineDifficultyAndMoreScreen> {
  double _rating = 0;
  String _ratingLabel;

  String _dropdownValue = 'Location.gym';

  @override
  void initState() {
    _ratingLabel = Difficulty.values[_rating.toInt()].translation;
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
                  Text(S.current.location, style: Headline6Bold),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              color: CardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: _dropdownValue,
                  dropdownColor: CardColor,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                  ),
                  style: BodyText1,
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue = value;
                      widget.locationCallback(value);
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Location.gym',
                      child: Text(Location.gym.translation),
                    ),
                    DropdownMenuItem(
                      value: 'Location.atHome',
                      child: Text(Location.atHome.translation),
                    ),
                    DropdownMenuItem(
                      value: 'Location.outdoor',
                      child: Text(Location.outdoor.translation),
                    ),
                    DropdownMenuItem(
                      value: 'Location.others',
                      child: Text(Location.others.translation),
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
                style: Headline6Bold,
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
                value: _rating,
                onChanged: (newRating) {
                  setState(() {
                    _rating = newRating;
                    _ratingLabel =
                        Difficulty.values[_rating.toInt()].translation;
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
