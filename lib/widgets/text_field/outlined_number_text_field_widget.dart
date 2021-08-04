import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/models/text_field_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class OutlinedNumberTextFieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextFieldModel model;
  final GlobalKey<FormState> formKey;
  final int? maxLength;
  final String? suffixText;
  final String? labelText;
  final String? Function(String?)? customValidator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const OutlinedNumberTextFieldWidget({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.model,
    required this.formKey,
    this.maxLength,
    this.suffixText,
    this.labelText,
    this.customValidator,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength ?? 8,
      focusNode: focusNode,
      controller: controller,
      style: TextStyles.body1,
      validator: customValidator ?? model.validator,
      onChanged: onChanged ?? (string) => model.onChanged(formKey, string),
      onFieldSubmitted: onFieldSubmitted ??
          (string) => model.onFieldSubmitted(formKey, string),
      keyboardAppearance: Brightness.dark,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+'))],
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.body1,
        suffixText: suffixText,
        suffixStyle: TextStyles.body1,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
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