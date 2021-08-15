import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view_models/text_field_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class FullScreenTextTextFieldWidget extends StatelessWidget {
  const FullScreenTextTextFieldWidget({
    Key? key,
    required this.controller,
    required this.formKey,
    this.focusNode,
    this.maxLength = 45,
    this.maxLines = 1,
    this.hintText,
    this.customValidator,
  }) : super(key: key);

  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final String? Function(String?)? customValidator;

  @override
  Widget build(BuildContext context) {
    final model = context.read(textFieldModelProvider);

    return Center(
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          focusNode: focusNode,
          maxLines: maxLines,
          maxLength: maxLength,
          controller: controller,
          style: TextStyles.headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            counterStyle: TextStyles.caption1,
            hintStyle: TextStyles.headline6_grey,
            hintText: hintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
          ),
          validator: customValidator ?? model.stringValidator,
          onChanged: (string) => model.onChanged(formKey, string),
          onSaved: (string) => model.onSaved(formKey, string),
          onFieldSubmitted: (string) => model.onFieldSubmitted(formKey, string),
        ),
      ),
    );
  }
}
