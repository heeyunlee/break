import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../constants.dart';
import 'app_preview_widget.dart';

typedef BoolCallback = void Function(bool value);

class PreviewScreen extends StatefulWidget {
  final BoolCallback callback;

  const PreviewScreen({Key key, this.callback}) : super(key: key);

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
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          if (Platform.isIOS)
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
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS%2Fapp_preview_5.png?alt=media&token=85220a42-5eb1-4a6a-996a-4e56016a0d0a',
                    subtitle: 'Create your Own Routine',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS%2Fapp_preview_1.png?alt=media&token=eef2b7d5-ff9d-4a45-8c5a-2d2f1d7d86c6',
                    subtitle: 'Save your Progress',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS%2Fapp_preview_2.png?alt=media&token=92d1a816-f1d0-4b2d-a389-24ea3c9768ad',
                    subtitle: 'Save your Progress',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS%2Fapp_preview_3.png?alt=media&token=bfff98db-c276-45d9-8945-6a985c3b541a',
                    subtitle: 'Save your Progress',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS%2Fapp_preview_4.png?alt=media&token=ee174a8a-5590-4dc4-94f3-e1cccf1e81da',
                    subtitle: 'Workout Seamlessly',
                  ),
                ],
              ),
            ),
          if (Platform.isAndroid)
            Container(
              height: size.height * 5 / 6,
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_2.png?alt=media&token=f60b1c4c-d6b8-4702-8f1e-0db286727cb8',
                    subtitle: 'Create Your Own Routine',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_1.png?alt=media&token=15e54bba-b995-425d-8e02-9ac60be667cb',
                    subtitle: 'Save your Progress',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_3.png?alt=media&token=a098e834-3483-4c20-8b85-7202ebc43231',
                    subtitle: 'Save your Progress',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_5.png?alt=media&token=faa1e4c4-9a8e-4854-a802-5f45fd103573',
                    subtitle: 'Save your Progress',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_4.png?alt=media&token=528f29e5-ba2f-4ac9-9ad9-00448a46f007',
                    subtitle: 'Workout Seamlessly',
                  ),
                ],
              ),
            ),
          Spacer(),
          Row(
            children: [
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      _showPreview = false;
                      widget.callback(_showPreview);
                    });
                  },
                  child: Text(S.current.skip, style: ButtonText),
                ),
              ),
              Expanded(
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 5,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: PrimaryColor,
                      activeDotScale: 1.5,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
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
                        HapticFeedback.mediumImpact();
                        _showPreview = false;
                        widget.callback(_showPreview);
                      }
                    });
                  },
                  child: Text(
                    (_currentPage == 4) ? S.current.getStarted : S.current.next,
                    style: ButtonText,
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
