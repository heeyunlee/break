import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInChangeNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void toggleBoolValue() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setBoolean(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

final signInChangeNotifierProvider =
    ChangeNotifierProvider((ref) => SignInChangeNotifier());
