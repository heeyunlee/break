import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';

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

  String? emailValidatorWithBool(String? value, {required bool submitted}) {
    if (submitted) {
      if (value != null) {
        final isEmailValid = EmailValidator.validate(value);

        if (!isEmailValid) {
          return S.current.invalidEmailValidationText;
        }
      }
    }

    return null;
  }

  String? firstNameValidatorWithBool(String? value, {required bool submitted}) {
    if (submitted) {
      if (value == null || value.isEmpty) {
        return S.current.emptyFirstNameText;
      }
    }
    return null;
  }

  String? lastNameValidatorWithBool(String? value, {required bool submitted}) {
    if (submitted) {
      if (value == null || value.isEmpty) {
        return S.current.emptyLastNameText;
      }
    }
    return null;
  }

  bool isPasswordValid(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String? passwordValidatorWithBool(String? value, {required bool submitted}) {
    if (submitted) {
      if (value != null) {
        final validator = isPasswordValid(value);

        if (!validator) {
          return S.current.emptyConfirmPasswordValidationtext;
        }
      }
    }
    return null;
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
