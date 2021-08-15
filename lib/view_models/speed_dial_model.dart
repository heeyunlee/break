import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final speedDialModelProvider = ChangeNotifierProvider(
  (ref) => SpeedDialModel(),
);

class SpeedDialModel with ChangeNotifier {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _childrenAnimation;

  bool get isOpen => _isOpen;
  AnimationController get controller => _controller;
  Animation<double> get childrenAnimation => _childrenAnimation;

  void init(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      value: _isOpen ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
    );

    _childrenAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void toggleAnimation() {
    HapticFeedback.mediumImpact();
    _isOpen = !_isOpen;

    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    notifyListeners();
  }
}
