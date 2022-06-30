import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PreviewScreenState extends ChangeNotifier {
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  set currentPageIndex(int value) {
    _currentPageIndex = value;
    notifyListeners();
  }

  Timer? _timer;

  Timer? get timer => _timer;

  int _currentWidgetIndex = 0;

  int get currentWidgetIndex => _currentWidgetIndex;

  void _setCurrentWdigetIndex(int widgetsLength) {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (_currentWidgetIndex < (widgetsLength - 1)) {
          _currentWidgetIndex += 1;
        } else {
          _currentWidgetIndex = 0;
        }

        notifyListeners();
      },
    );
  }

  void onVisibilityChanged(VisibilityInfo visibilityInfo, int widgetsLength) {
    if (visibilityInfo.visibleFraction == 0) {
      _timer?.cancel();
    } else {
      _setCurrentWdigetIndex(widgetsLength);
    }
  }

  Future<bool> onPressed() async {
    if (_currentPageIndex >= 2) {
      return true;
    } else {
      _currentPageIndex++;
      HapticFeedback.mediumImpact();

      return false;
    }
  }
}
