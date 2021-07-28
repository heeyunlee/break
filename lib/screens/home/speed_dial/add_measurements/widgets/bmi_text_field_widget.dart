import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../add_measurements_model.dart';

class BMITextFieldWidget extends StatelessWidget {
  final AddMeasurementsModel model;

  const BMITextFieldWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        focusNode: model.focusNode4,
        controller: model.bmiController,
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
        ],
        maxLength: 8,
        decoration: InputDecoration(
          labelText: 'BMI',
          labelStyle: TextStyles.body1,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kSecondaryColor),
          ),
          counterText: '',
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixStyle: TextStyles.body1,
        ),
        style: TextStyles.body1,
        onChanged: model.onChanged,
        onFieldSubmitted: model.onFieldSubmitted,
      ),
    );
  }
}
