import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../view_models/sign_in_screen_model.dart';

class PreviewModel extends ChangeNotifier {
  int get currentPageIndex => _currentPageIndex;
  int get currentWidgetIndex => _currentWidgetIndex;
  Timer? get timer => _timer;
  PageController get pageController => _pageController;

  int _currentPageIndex = 0;
  int _currentWidgetIndex = 0;
  Timer? _timer;
  // Widget _currentWidget = const ActivityRing(
  //   key: Key('activityRing'),
  //   muscleName: 'Chest',
  //   liftedWeights: 10000,
  //   weightGoal: 20000,
  //   consumedProtein: 75,
  //   proteinGoal: 150,
  //   unit: UnitOfMass.kilograms,
  //   cardColor: Colors.transparent,
  //   elevation: 0,
  // );
  late PageController _pageController;

  void init() {
    _pageController = PageController();

    _pageController.addListener(() {
      _currentPageIndex = _pageController.page?.toInt() ?? 0;

      notifyListeners();
    });
  }

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

  Future<void> onPressed(BuildContext context) async {
    if (_currentPageIndex >= 2) {
      SignInScreenModel.show(context);
    } else {
      _currentPageIndex++;
      HapticFeedback.mediumImpact();

      _pageController.animateToPage(
        _currentPageIndex,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 300),
      );
    }

    notifyListeners();
  }

  // List<Widget> get previewWidgets => [
  //       _currentWidget,
  //       SampleWidgets.weeklyWeightsBarChartPreview,
  //       const WeeklyWorkoutSummarySampleWidget(padding: 24),
  //       SampleWidgets().weeklyProteinsBarChartPreview,
  //       SampleWidgets().weeklyFatBarChartPreview,
  //       const MostRecentWorkoutSampleWidget(padding: 24),
  //       const LatestBodyFatSampleWidget(padding: 16),
  //       const WeeklyMeasurementsSampleWidget(padding: 24),
  //       SampleWidgets().weeklyCarbsBarChartPreview,
  //       const LatestBodyWeightSampleWidget(padding: 16),
  //       SampleWidgets().weeklyCaloriesChartPreview,
  //     ];
}
