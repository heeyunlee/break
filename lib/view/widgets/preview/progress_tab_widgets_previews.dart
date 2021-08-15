import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../view_models/preview_screen_model.dart';

class ProgressTabWidgetsPreviews extends StatelessWidget {
  const ProgressTabWidgetsPreviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final size = MediaQuery.of(context).size;
        final model = watch(previewScreenModelProvider);

        return VisibilityDetector(
          key: const Key('preview-widgets'),
          onVisibilityChanged: model.onVisibilityChanged,
          child: SizedBox(
            height: size.width,
            width: size.width,
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: model.currentWidget,
            ),
          ),
        );
      },
    );
  }
}
