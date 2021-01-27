import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'create_new_routine_screen.dart';

class CreateNewRoutineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        '새로운 루틴 추가',
        style: BodyText1.copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: () => CreateNewRoutineScreen.show(context),
      onLongPress: () {},
    );
  }
}
