import 'package:flutter/material.dart';

import 'constants.dart';

class ButtonStyles {
  static final textButton_1 = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return kGrey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return kPrimaryColor.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return kButtonTextGrey;
      }
      return kButtonText;
    }),
  );

  static final textButton_google = ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return kGrey600;
      return Colors.white;
    }),
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) return Colors.grey;
      return kPrimaryColor.withOpacity(0.12);
    }),
    textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
      if (states.contains(MaterialState.disabled)) {
        return kGoogleSignInStyleWhite30;
      }
      return kGoogleSignInStyleWhite;
    }),
  );
}
