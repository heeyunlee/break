import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../constants.dart';
import 'sign_in_provider.dart';
import 'widgets/app_preview_widget.dart';

class PreviewScreen extends StatefulWidget {
  final BoolCallback callback;

  const PreviewScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _showPreview = true;

  int _currentPage = 0;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final os = Platform.operatingSystem;
    final locale = Intl.getCurrentLocale();
    final osLocale = os + locale;

    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          Container(
            height: size.height * 5 / 6,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                // Progress 1
                AppPreviewWidget(
                  imageRoot: previewImages[osLocale]![0],
                  subtitle: S.current.seeYourProgress,
                ),

                // Progress 2
                AppPreviewWidget(
                  imageRoot: previewImages[osLocale]![1],
                  subtitle: S.current.seeYourProgress,
                ),

                // Create your own Routine
                AppPreviewWidget(
                  imageRoot: previewImages[osLocale]![2],
                  subtitle: S.current.createYourOwnRoutine,
                ),

                // Workout Player
                AppPreviewWidget(
                  imageRoot: previewImages[osLocale]![3],
                  subtitle: S.current.logYourWorkout,
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      _showPreview = false;
                      widget.callback(_showPreview);
                    });
                  },
                  child: Text(S.current.skip, style: kButtonText),
                ),
              ),
              Expanded(
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: const WormEffect(
                      activeDotColor: kPrimaryColor,
                      dotHeight: 9,
                      dotWidth: 9,
                      spacing: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (_currentPage < 4) {
                        HapticFeedback.mediumImpact();
                        _currentPage++;
                        _pageController.animateToPage(
                          _currentPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        //
                        HapticFeedback.mediumImpact();
                        _showPreview = false;
                        widget.callback(_showPreview);
                      }
                    });
                  },
                  child: Text(
                    (_currentPage == 4) ? S.current.start : S.current.next,
                    style: kButtonText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 38),
        ],
      ),
    );
  }
}
