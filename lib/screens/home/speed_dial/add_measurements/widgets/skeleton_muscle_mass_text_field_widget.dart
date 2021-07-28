import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../add_measurements_model.dart';

class SkeletonMuscleMassTextFieldWidget extends StatelessWidget {
  final AddMeasurementsModel model;
  final String unit;

  const SkeletonMuscleMassTextFieldWidget({
    Key? key,
    required this.model,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('SkeletonMuscleMassTextField Widget building...');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        focusNode: model.focusNode3,
        controller: model.smmController,
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
        ],
        maxLength: 8,
        decoration: InputDecoration(
          counterText: '',
          labelText: S.current.skeletalMuscleMass,
          labelStyle: TextStyles.body1,
          contentPadding: const EdgeInsets.all(16),
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
          suffixText: unit,
          suffixStyle: TextStyles.body1,
        ),
        style: TextStyles.body1,
        onChanged: model.onChanged,
        onFieldSubmitted: model.onFieldSubmitted,
      ),
    );
  }
}
