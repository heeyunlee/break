import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'widgets/activity_ring_preview_widget.dart';
import 'widgets/latest_body_fat_preview_widget.dart';
import 'widgets/weekly_lifted_weights_preview_widget.dart';
import 'widgets/weekly_measurement_preview_widget.dart';
import 'widgets/weekly_nutritions_chart_preview_widget.dart';
import 'widgets/weekly_workout_summary_preview_widget.dart';

final previewScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PreviewScreenModel(),
);

class PreviewScreenModel extends ChangeNotifier {
  int _currentWidgetIndex = 0;
  Timer? _timer;
  Widget _currentWidget = ActivityRingPreviewWidget();

  int get currentWidgetIndex => _currentWidgetIndex;
  Timer? get timer => _timer;
  Widget get currentWidget => _currentWidget;

  void setCurrentWdigetIndex() {
    _timer?.cancel();

    _timer = Timer.periodic(
      Duration(seconds: 4),
      (timer) {
        if (_currentWidgetIndex < (currentPreviewWidgetList.length - 1)) {
          _currentWidgetIndex += 1;
        } else {
          _currentWidgetIndex = 0;
        }
        _currentWidget = currentPreviewWidgetList[_currentWidgetIndex];

        notifyListeners();
      },
    );
  }

  void onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction == 0) {
      _timer?.cancel();
    } else {
      setCurrentWdigetIndex();
    }
  }

  final List<Widget> currentPreviewWidgetList = [
    ActivityRingPreviewWidget(),
    WeeklyWorkoutSummaryPreviewWidget(),
    LatestBodyFatPreviewWidget(),
    WeeklyLiftedWeightsWidget(),
    WeeklyMeasurementPreviewWidget(),
    WeeklyNutritionChartPreviewWidget(),
  ];

  static final GlobalKey<NavigatorState> previewScreenNavigatorKey =
      GlobalKey<NavigatorState>();
}
