import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'create_new_routine_screen.dart';

class CreateNewRoutineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CreateNewRoutineScreen.show(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                color: Grey800,
                child: const Icon(Icons.add_rounded, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Text(
                'Create New Routine',
                style: BodyText1Bold,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
