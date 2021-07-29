import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../add_nutrition_screen_model.dart';

class NutritionTextFieldWidget extends StatelessWidget {
  final AddNutritionScreenModel model;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String suffixText;
  final String labelText;

  const NutritionTextFieldWidget({
    Key? key,
    required this.model,
    required this.focusNode,
    required this.controller,
    required this.suffixText,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 8,
      focusNode: focusNode,
      controller: controller,
      style: TextStyles.body1,
      validator: model.validator,
      onChanged: model.onChanged,
      onFieldSubmitted: model.onFieldSubmitted,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))],
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.body1,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        suffixText: suffixText,
        suffixStyle: TextStyles.body1,
        counterText: '',
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
    );
  }
}
