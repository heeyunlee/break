import 'package:flutter/cupertino.dart';
import 'package:workout_player/screens/search_tab/more_routine_results.dart';

import '../constants.dart';

class WorkoutFilterButton extends StatefulWidget {
  const WorkoutFilterButton({
    Key key,
    this.tagTitle,
    this.searchCategory,
    this.buttonTitle,
  }) : super(key: key);

  final String tagTitle;
  final String searchCategory;
  final String buttonTitle;

  @override
  _WorkoutFilterButtonState createState() => _WorkoutFilterButtonState();
}

class _WorkoutFilterButtonState extends State<WorkoutFilterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Primary600Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(widget.buttonTitle, style: Caption1),
        onPressed: () => MoreRoutineResult.show(
          tag: widget.tagTitle,
          context: context,
          searchCategory: widget.searchCategory,
        ),
      ),
    );
  }
}
