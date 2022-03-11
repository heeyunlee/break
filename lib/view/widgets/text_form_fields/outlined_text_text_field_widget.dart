import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view_models/text_field_model.dart';
import 'package:workout_player/styles/text_styles.dart';

/// Creates a custom [TextFormField] widget with outlined border that is
///
/// [enabled] =  `Colors.grey`
///
/// [focused] = `kSecondaryColor`
///
/// [error] and [focusedError] = `kSecondaryColor`
///
/// This widget uses [TextFieldModel] for `customValidator`, `onChanged`,
/// `onSaved`, and `onFieldSubmitted` functions by default, but can take custom
/// values.
class OutlinedTextTextFieldWidget extends ConsumerWidget {
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
    required this.formKey,
    this.maxLength,
    this.maxLines,
    this.suffixText,
    this.labelText,
    this.customValidator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.hintText,
    this.contentPadding = const EdgeInsets.all(16),
  }) : super(key: key);

  /// Default is `false`
  final bool? autofocus;

  /// Default value is `true`
  final bool? autocorrect;

  /// Default value is `false`
  final bool? enableSuggestions;

  /// Default value is `false`
  final bool? obscureText;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode focusNode;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final int? maxLength;
  final int? maxLines;
  final String? suffixText;
  final String? labelText;
  final String? Function(String?)? customValidator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final String? hintText;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final model = ref.read(textFieldModelProvider);

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
      onSaved: onSaved ?? (string) => model.onSaved(formKey, string),
      onChanged: onChanged ?? (string) => model.onChanged(formKey, string),
      onFieldSubmitted: onFieldSubmitted ??
          (string) => model.onFieldSubmitted(formKey, string),
      keyboardAppearance: Brightness.dark,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.done,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyles.body1,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
        suffixStyle: TextStyles.body1,
        hintText: hintText,
        hintStyle: TextStyles.body1Grey,
        counterText: '',
        counterStyle: TextStyles.overlineGrey,
        contentPadding: contentPadding,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.secondary),
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
