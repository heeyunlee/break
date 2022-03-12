import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/view/preview/widgets/activity_ring_sample_widget.dart';
import 'package:workout_player/view/preview/widgets/latest_body_fat_sample_widget.dart';
import 'package:workout_player/view/preview/widgets/latest_body_weight_sample_widget.dart';
import 'package:workout_player/view/preview/widgets/most_recent_workout_sample_widget.dart';
import 'package:workout_player/view/preview/widgets/sample_widgets.dart';
import 'package:workout_player/view/preview/widgets/weekly_measurements_sample_widget.dart';
import 'package:workout_player/view/preview/widgets/weekly_workout_summary_sample_widget.dart';
import 'sign_in_screen_model.dart';

final previewScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PreviewScreenModel(),
);

class PreviewScreenModel extends ChangeNotifier {
  int _currentPageIndex = 0;
  int _currentWidgetIndex = 0;
  Timer? _timer;
  Widget _currentWidget = const ActivityRingSampleWidget(
    margin: 16,
    color: Colors.transparent,
  );
  late PageController _pageController;

  int get currentPageIndex => _currentPageIndex;
  int get currentWidgetIndex => _currentWidgetIndex;
  Timer? get timer => _timer;
  Widget get currentWidget => _currentWidget;
  PageController get pageController => _pageController;

  void init() {
    _pageController = PageController();

    _pageController.addListener(() {
      _currentPageIndex = _pageController.page?.toInt() ?? 0;

      notifyListeners();
    });
  }

  void _setCurrentWdigetIndex() {
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

        notifyListeners();
      },
    );
  }

  void onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction == 0) {
      _timer?.cancel();
    } else {
      _setCurrentWdigetIndex();
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

  final List<Widget> currentPreviewWidgetList = [
    const ActivityRingSampleWidget(margin: 16, color: Colors.transparent),
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
