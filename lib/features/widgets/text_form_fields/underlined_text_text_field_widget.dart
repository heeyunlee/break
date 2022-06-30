import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view_models/text_field_model.dart';
import 'package:workout_player/styles/text_styles.dart';

class UnderlinedTextTextFieldWidget extends ConsumerWidget {
  const UnderlinedTextTextFieldWidget({
    Key? key,
    required this.controller,
    required this.formKey,
    this.focusNode,
    this.maxLength = 45,
    this.maxLines = 1,
    this.hintText,
    this.validator,
    this.inputStyle = TextStyles.headline5,
    this.hintStyle = TextStyles.headline6Grey,
    this.counterStyle = TextStyles.caption1,
    this.counterAsSuffix = false,
    this.autoFocus = true,
    this.textAlign = TextAlign.center,
    this.contentPadding,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final TextStyle? inputStyle;
  final TextStyle? hintStyle;
  final TextStyle? counterStyle;
  final bool? counterAsSuffix;
  final bool? autoFocus;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final model = ref.watch(textFieldModelProvider);
    final counter = '${controller.text.length}/$maxLength';

    return TextFormField(
      focusNode: focusNode,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      style: inputStyle,
      autofocus: autoFocus!,
      textAlign: textAlign!,
      decoration: InputDecoration(
        suffixText: counterAsSuffix! ? counter : null,
        suffixStyle: counterStyle,
        counterText: counterAsSuffix! ? '' : null,
        counterStyle: counterStyle,
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator ?? model.stringValidator,
      onChanged: onChanged ?? (string) => model.onChanged(formKey, string),
      onSaved: onSaved ?? (string) => model.onSaved(formKey, string),
      onFieldSubmitted: onFieldSubmitted ??
          (string) => model.onFieldSubmitted(formKey, string),
    );
  }
}
