import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/home/library_tab/routine/create_routine/create_new_routine_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class NewRoutineTitleWidget extends StatelessWidget {
  final CreateNewROutineModel model;

  const NewRoutineTitleWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          maxLines: 1,
          maxLength: 45,
          style: TextStyles.headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          controller: model.textEditingController,
          decoration: InputDecoration(
            counterStyle: TextStyles.caption1,
            hintStyle: TextStyles.headline6_grey,
            hintText: S.current.routineTitleHintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
          ),
          onChanged: model.onChanged,
          onSaved: model.onSaved,
          onFieldSubmitted: model.onFieldSubmitted,
        ),
      ),
    );
  }
}
