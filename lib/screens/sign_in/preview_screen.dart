import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/mixpanel_manager.dart';

import '../../constants.dart';
import 'widgets/app_preview_widget.dart';

typedef BoolCallback = void Function(bool value);

class PreviewScreen extends StatefulWidget {
  final BoolCallback callback;

  const PreviewScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late Mixpanel mixpanel;
  bool _showPreview = true;

  final List<String> _iOSEnglish = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_1.png?alt=media&token=b4a6aaac-544b-455b-a884-f07e74f85e2f',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_2.png?alt=media&token=12c5c7ae-f535-4ddc-9b78-232f5d06cede',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_3.png?alt=media&token=9e03426c-b9a1-4131-ba36-3ce209b898d3',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_4.png?alt=media&token=b229b531-9c78-470d-9158-f54dfd5af7b8',
  ];
  final List<String> _iOSKorean = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_1.png?alt=media&token=5c33e408-ec5a-40a7-98a9-90f5504608b1',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_2.png?alt=media&token=c39f0b86-3be9-49e5-bedb-4340be9b766b',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_3.png?alt=media&token=01cb2009-0e8e-4ec7-b972-573a0d2145a2',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_4.png?alt=media&token=75c82a5e-f15e-4af0-a2c2-d500518ceba7',
  ];
  final List<String> _androidEnglish = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_1.png?alt=media&token=9e5da9a9-a16b-4d04-87b7-c4c55bede755',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_2.png?alt=media&token=8d4c4cdb-3f5c-45f2-90ae-273d130bf265',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_3.png?alt=media&token=8dacc278-f31c-4c55-a46d-a57b77b5d2f8',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_4.png?alt=media&token=6856772c-b2af-467b-b418-6adaa357a119',
  ];
  final List<String> _androidKorean = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_1.png?alt=media&token=d550d6bf-ac1a-409e-adce-4d14ca0eaed2',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_2.png?alt=media&token=97b7ba7e-cac5-40a4-8376-c2abb3cb2d92',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_3.png?alt=media&token=0d7507f2-7b22-4827-afe2-b9504c73529c',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_4.png?alt=media&token=bcb906b1-7bf2-4134-b171-2d6e3b625fb8',
  ];

  int _currentPage = 0;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  Future<void> initMixPanel() async {
    mixpanel = await MixpanelManager.init();
  }

  @override
  Widget build(BuildContext context) {
    initMixPanel();

    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          // Container(
          //   height: size.height * 5 / 6,
          //   child: PageView(
          //     controller: _pageController,
          //     onPageChanged: (page) {
          //       setState(() {
          //         _currentPage = page;
          //       });
          //     },
          //     children: <Widget>[
          //       AppPreviewWidget(
          //         imageRoot: _iOSEnglish[0],
          //         subtitle: S.current.createYourOwnWorkout,
          //       ),
          //       AppPreviewWidget(
          //         imageRoot: _iOSEnglish[1],
          //         subtitle: S.current.logYourWorkout,
          //       ),
          //       AppPreviewWidget(
          //         imageRoot: _iOSEnglish[2],
          //         subtitle: S.current.seeYourProgress,
          //       ),
          //       AppPreviewWidget(
          //         imageRoot: _iOSEnglish[3],
          //         subtitle: S.current.shareWithOthers,
          //       ),
          //     ],
          //   ),
          // ),
          // TODO: MAKE THIS BETTER
          if (Platform.isIOS && Intl.getCurrentLocale() == 'en')
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
                  AppPreviewWidget(
                    imageRoot: _iOSEnglish[0],
                    subtitle: S.current.createYourOwnWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _iOSEnglish[1],
                    subtitle: S.current.logYourWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _iOSEnglish[2],
                    subtitle: S.current.seeYourProgress,
                  ),
                  AppPreviewWidget(
                    imageRoot: _iOSEnglish[3],
                    subtitle: S.current.shareWithOthers,
                  ),
                ],
              ),
            ),
          if (Platform.isIOS && Intl.getCurrentLocale() == 'ko')
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
                  AppPreviewWidget(
                    imageRoot: _iOSKorean[0],
                    subtitle: S.current.createYourOwnWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _iOSKorean[1],
                    subtitle: S.current.logYourWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _iOSKorean[2],
                    subtitle: S.current.seeYourProgress,
                  ),
                  AppPreviewWidget(
                    imageRoot: _iOSKorean[3],
                    subtitle: S.current.shareWithOthers,
                  ),
                ],
              ),
            ),
          if (Platform.isAndroid && Intl.getCurrentLocale() == 'en')
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
                  AppPreviewWidget(
                    imageRoot: _androidEnglish[0],
                    subtitle: S.current.createYourOwnWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _androidEnglish[1],
                    subtitle: S.current.logYourWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _androidEnglish[2],
                    subtitle: S.current.seeYourProgress,
                  ),
                  AppPreviewWidget(
                    imageRoot: _androidEnglish[3],
                    subtitle: S.current.shareWithOthers,
                  ),
                ],
              ),
            ),
          if (Platform.isAndroid && Intl.getCurrentLocale() == 'ko')
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
                  AppPreviewWidget(
                    imageRoot: _androidKorean[0],
                    subtitle: S.current.createYourOwnWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _androidKorean[1],
                    subtitle: S.current.logYourWorkout,
                  ),
                  AppPreviewWidget(
                    imageRoot: _androidKorean[2],
                    subtitle: S.current.seeYourProgress,
                  ),
                  AppPreviewWidget(
                    imageRoot: _androidKorean[3],
                    subtitle: S.current.shareWithOthers,
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
                      if (_currentPage < 3) {
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
                    (_currentPage == 3) ? S.current.start : S.current.next,
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
