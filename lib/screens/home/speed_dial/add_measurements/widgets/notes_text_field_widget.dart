import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../add_measurements_model.dart';

class NotesTextFieldWidget extends StatelessWidget {
  final AddMeasurementsModel model;

  const NotesTextFieldWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('NotesTextField Widget building...');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        focusNode: model.focusNode5,
        controller: model.notesController,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: S.current.notes,
          labelStyle: TextStyles.body1,
          contentPadding: EdgeInsets.all(16),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kSecondaryColor),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        style: TextStyles.body1,
        onChanged: model.onChanged,
        onFieldSubmitted: model.onFieldSubmitted,
      ),
    );
  }
}
