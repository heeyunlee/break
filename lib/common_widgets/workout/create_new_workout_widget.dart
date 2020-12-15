import 'package:flutter/material.dart';

import '../../constants.dart';

class CreateNewWorkoutWidget extends StatelessWidget {
  final String listTileTitle;
  final Function createNewWorkout;

  CreateNewWorkoutWidget(
    this.listTileTitle,
    this.createNewWorkout,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          height: 56,
          width: 56,
          color: Grey800,
          child: Icon(
            Icons.add_rounded,
            color: Grey200,
          ),
        ),
        title: Text(
          listTileTitle,
          style: BodyText1Bold,
        ),
        onTap: createNewWorkout,
        onLongPress: () {},
      ),
    );
  }
}
