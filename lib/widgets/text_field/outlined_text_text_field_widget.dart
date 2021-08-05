import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/models/text_field_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class OutlinedTextTextFieldWidget extends StatelessWidget {
  final bool? autofocus;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextFieldModel model;
  final GlobalKey<FormState> formKey;
  final int? maxLength;
  final int? maxLines;
  final String? suffixText;
  final String? labelText;
  final String? Function(String?)? customValidator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final String? hintText;

  const OutlinedTextTextFieldWidget({
    Key? key,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    required this.focusNode,
    required this.controller,
    required this.model,
    required this.formKey,
    this.maxLength,
    this.maxLines,
    this.suffixText,
    this.labelText,
    this.customValidator,
    this.onChanged,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus!,
      autocorrect: autocorrect!,
      enableSuggestions: enableSuggestions!,
      obscureText: obscureText!,
      maxLength: maxLength,
      maxLines: maxLines,
      focusNode: focusNode,
      controller: controller,
      style: TextStyles.body1,
      validator: customValidator ?? model.stringValidator,
      onChanged: onChanged ?? (string) => model.onChanged(formKey, string),
      onFieldSubmitted: onFieldSubmitted ??
          (string) => model.onFieldSubmitted(formKey, string),
      keyboardAppearance: Brightness.dark,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.body1,
        suffixText: suffixText,
        suffixStyle: TextStyles.body1,
        hintText: hintText,
        hintStyle: TextStyles.body1_grey,
        counterText: '',
        counterStyle: TextStyles.overline_grey,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}
