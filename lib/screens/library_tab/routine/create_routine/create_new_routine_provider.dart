import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsCreateRoutineButtonPressedNotifier extends ChangeNotifier {
  bool _isButtonPressed = false;
  bool get isButtonPressed => _isButtonPressed;

  void toggleBoolValue() {
    _isButtonPressed = !_isButtonPressed;
    notifyListeners();
  }

  void setBoolean(bool value) {
    _isButtonPressed = value;
    notifyListeners();
  }
}

final isCreateRoutineButtonPressedProvider = ChangeNotifierProvider(
  (ref) => IsCreateRoutineButtonPressedNotifier(),
);
