import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'main_model.dart';

final previewScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PreviewScreenModel(),
);

class PreviewScreenModel extends ChangeNotifier {
  int _currentPage = 0;
  int _currentWidgetIndex = 0;
  Timer? _timer;
  Widget _currentWidget = const ActivityRingSampleWidget();
  PageController _pageController = PageController();

  int get currentPage => _currentPage;
  int get currentWidgetIndex => _currentWidgetIndex;
  Timer? get timer => _timer;
  Widget get currentWidget => _currentWidget;
  PageController get pageController => _pageController;

  void _setCurrentWdigetIndex() {
    logger.d('_setCurrentWdigetIndex called on PreviewScreen');
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (_currentWidgetIndex < (currentPreviewWidgetList.length - 1)) {
          _currentWidgetIndex += 1;
        } else {
          _currentWidgetIndex = 0;
        }
        _currentWidget = currentPreviewWidgetList[_currentWidgetIndex];

        logger.d('timer is active ${_timer?.isActive}');

        notifyListeners();
      },
    );
  }

  void onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction == 0) {
      _timer?.cancel();
      logger.d('timer is active ${_timer?.isActive}');
    } else {
      _setCurrentWdigetIndex();
    }
  }

  final List<Widget> currentPreviewWidgetList = [
    const ActivityRingSampleWidget(margin: 16),
    SampleWidgets().weeklyWeightsBarChartPreview,
    const WeeklyWorkoutSummarySampleWidget(padding: 24),
    SampleWidgets().weeklyProteinsBarChartPreview,
    SampleWidgets().weeklyFatBarChartPreview,
    const MostRecentWorkoutSampleWidget(padding: 24),
    const LatestBodyFatSampleWidget(padding: 16),
    const WeeklyMeasurementsSampleWidget(padding: 24),
    SampleWidgets().weeklyCarbsBarChartPreview,
    const LatestBodyWeightSampleWidget(padding: 16),
    SampleWidgets().weeklyCaloriesChartPreview,
  ];
}
