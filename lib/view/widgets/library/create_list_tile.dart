import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/screens/library/choose_title_screen.dart';

import '../../../view_models/create_new_routine_model.dart';

class CreateListTile extends StatelessWidget {
  const CreateListTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        // splashColor: kPrimaryColor.withOpacity(0.2),
        // highlightColor: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        onTap: () => ChooseTitleScreen.show<CreateNewRoutineModel>(
          context,
          formKey: CreateNewRoutineModel.formKey,
          provider: createNewROutineModelProvider,
          appBarTitle: S.current.routineTitleTitle,
          hintText: S.current.routineTitleHintText,
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                child: const Icon(Icons.add_rounded, size: 32),
              ),
              const SizedBox(width: 16),
              Text(title, style: TextStyles.body1_bold),
            ],
          ),
        ),
      ),
    );
  }
}