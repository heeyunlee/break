import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/utils/string_validator.dart';

final textFieldModelProvider = ChangeNotifierProvider(
  (ref) => TextFieldModel(),
);

/// Creates a [ChangeNotifier] that can be used for [TextField] or [TextFormField]
class TextFieldModel with ChangeNotifier {
  String? validator(String? value) {
    if (value!.isEmpty) {
      return null;
    } else {
      final tryParse = num.tryParse(value);

      if (tryParse == null) {
        return S.current.pleaseEnderValidValue;
      } else {
        return null;
      }
    }
  }

  String? stringValidator(String? value) {
    return null;
  }

  String? emailValidatorWithBool(String? value, bool submitted) {
    if (submitted) {
      if (value != null) {
        final validator = StringValidatorBase();
        final isEmailValid = validator.isEmailValid(value);

        if (!isEmailValid) {
          return S.current.invalidEmailValidationText;
        }
      }
    }
  }

  String? firstNameValidatorWithBool(String? value, bool submitted) {
    if (submitted) {
      if (value == null || value.isEmpty) {
        return S.current.emptyFirstNameText;
      }
    }
  }

  String? lastNameValidatorWithBool(String? value, bool submitted) {
    if (submitted) {
      if (value == null || value.isEmpty) {
        return S.current.emptyLastNameText;
      }
    }
  }

  String? passwordValidatorWithBool(String? value, bool submitted) {
    if (submitted) {
      if (value != null) {
        final validator = StringValidatorBase();
        final isPasswordValid = validator.isPasswordValid(value);

        if (!isPasswordValid) {
          return S.current.emptyConfirmPasswordValidationtext;
        }
      }
    }
  }

  void onChanged(GlobalKey<FormState> formKey, String value) {
    final form = formKey.currentState!;
    form.validate();

    notifyListeners();
  }

  void onSaved(GlobalKey<FormState> formKey, String? value) {
    final form = formKey.currentState!;
    form.validate();

    notifyListeners();
  }

  void onFieldSubmitted(GlobalKey<FormState> formKey, String value) {
    final form = formKey.currentState!;
    form.validate();

    notifyListeners();
  }
}
