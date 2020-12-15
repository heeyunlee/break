import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class WorkoutSmallCard extends StatefulWidget {
  final String workoutTitle;
  final Key key;

  WorkoutSmallCard(this.workoutTitle, {this.key});

  @override
  _WorkoutSmallCardState createState() => _WorkoutSmallCardState();
}

class _WorkoutSmallCardState extends State<WorkoutSmallCard> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.symmetric(
          horizontal: _isAdded == false ? 16 : 14, vertical: 4),
      decoration: BoxDecoration(
        border: _isAdded == false
            ? null
            : Border.all(color: PrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(10.0),
        color: _isAdded == false ? CardColor : FocusedColor,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 16),
          Text(
            widget.workoutTitle,
            style: BodyText2,
          ),
          Spacer(),
          IconButton(
            icon: _isAdded == false
                ? SvgPicture.asset('assets/icons/Icon-Add_Workout.svg')
                : Icon(Icons.check_rounded, color: PrimaryColor),
            onPressed: () {
              setState(() {
                _isAdded = !_isAdded;
                print(_isAdded);
              });
            },
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
