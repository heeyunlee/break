import 'package:email_validator/email_validator.dart';
import 'package:workout_player/generated/l10n.dart';

abstract class StringValidator {
  bool isEmailValid(String email);
  bool isPasswordValid(String password);
  bool isFirstNameValid(String name);
  bool isLastNameValid(String name);
}

class StringValidatorBase implements StringValidator {
  @override
  bool isEmailValid(String email) {
    if (EmailValidator.validate(email, false, true)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isFirstNameValid(String? name) {
    if (name == null || name.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  bool isLastNameValid(String? name) {
    if (name == null || name.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  bool isPasswordValid(String? password) {
    if (password == null || password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // // TODO: FIX HERE
  // @override
  // String Function(String) isPasswordStrong(String password) {
  //   if (password.isEmpty || password == null) {
  //     return (_) => S.current.emptyPasswordValidationText;
  //   }
  // }
}

class EmailAndPasswordValidators {
  final StringValidator validator = StringValidatorBase();
  final String invalidEmailText = S.current.invalidEmailValidationText;
  final String emptyPasswordText = S.current.emptyPasswordValidationText;
  final String emptyFirstNameText = S.current.emptyFirstNameText;
  final String emptyLastNameText = S.current.emptyLastNameText;
  final String emptyConfirmPasswordText =
      S.current.emptyConfirmPasswordValidationtext;
}
