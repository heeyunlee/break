import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../add_measurements_model.dart';

class BodyFatTextFieldWidget extends StatelessWidget {
  final AddMeasurementsModel model;

  const BodyFatTextFieldWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('BodyFat TextField Widget building...');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        focusNode: model.focusNode2,
        controller: model.bodyFatController,
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
        ],
        maxLength: 8,
        decoration: InputDecoration(
          counterText: '',
          labelText: S.current.bodyFat,
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
          suffixText: '%',
          suffixStyle: TextStyles.body1,
        ),
        style: TextStyles.body1,
        onChanged: model.onChanged,
        onFieldSubmitted: model.onFieldSubmitted,
      ),
    );
  }
}
