import 'package:email_validator/email_validator.dart';
import 'package:workout_player/generated/l10n.dart';

abstract class StringValidator {
  bool isEmailValid(String email);
  bool isPasswordValid(String password);
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
  bool isPasswordValid(String password) {
    if (password == null || password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  bool isConfirmPasswordValid(String password) {
    if (password == null || password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String Function(String) isPasswordStrong(String password) {
    if (password.isEmpty || password == null) {
      return (_) => S.current.emptyPasswordValidationText;
    }
  }
}

class EmailAndPasswordValidators {
  final StringValidator validator = StringValidatorBase();
  final String invalidEmailText = S.current.invalidEmailValidationText;
  final String emptyPasswordText = S.current.emptyPasswordValidationText;
  final String emptyConfirmPasswordText =
      S.current.emptyConfirmPasswordValidationtext;
}
