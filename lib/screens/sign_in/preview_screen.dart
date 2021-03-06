import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2FiOS%2Fapp_preview_2.png?alt=media&token=2fd93bff-52b9-48c9-ab31-e3863a4025be',
                    subtitle: 'Save your Routines',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2FiOS%2Fapp_preview_3.png?alt=media&token=5c9220eb-1e35-4e30-9194-37de19ff2e4f',
                    subtitle: 'See your Activities',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2FiOS%2Fapp_preview_4.png?alt=media&token=31cd40c9-d3f1-4f16-8ce4-d2d239955e7f',
                    subtitle: 'Set a timer',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2FiOS%2Fapp_preview_5.png?alt=media&token=3231ae19-d02d-4b92-a83f-997509178d74',
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
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_1.png?alt=media&token=c1c548e3-f398-4a32-a6c1-b5bcd94f4ff4',
                    subtitle: 'Save your Routines',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_2.png?alt=media&token=1b931226-e0e3-4716-9474-f360fff7e74a',
                    subtitle: 'See your Activities',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_3.png?alt=media&token=86b16501-0a2a-4234-904a-bdb73c218e9f',
                    subtitle: 'Set a timer',
                  ),
                  const AppPreviewWidget(
                    imageRoot:
                        'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/app_preview%2Fandroid%2Fapp_preview_android_4.png?alt=media&token=58b69309-2c63-4434-9a99-6b152f3b63c6',
                    subtitle: 'Workout Seamlessly',
                  ),
                ],
              ),
            ),
          Spacer(),
          Row(
            children: [
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    HapticFeedback.mediumImpact();
                    _showPreview = false;
                    widget.callback(_showPreview);
                  });
                },
                child: Text(
                  'SKIP',
                  style: ButtonText,
                ),
              ),
              Expanded(
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
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
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_currentPage < 3) {
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
                  (_currentPage == 3) ? 'DONE' : 'NEXT',
                  style: ButtonText,
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
