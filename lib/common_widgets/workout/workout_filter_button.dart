import 'package:flutter/cupertino.dart';

import '../../constants.dart';

class WorkoutFilterButton extends StatefulWidget {
  final String filterName;

  const WorkoutFilterButton({Key key, this.filterName}) : super(key: key);

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
        child: Text(widget.filterName, style: Caption1),
        onPressed: () {},
      ),
    );
  }
}
