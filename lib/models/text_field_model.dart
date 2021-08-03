import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';

final textFieldModelProvider = ChangeNotifierProvider(
  (ref) => TextFieldModel(),
);

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

  void onChanged(GlobalKey<FormState> formKey, String value) {
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
