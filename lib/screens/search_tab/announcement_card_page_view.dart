import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/create_new_routine_screen.dart';
import 'package:workout_player/screens/speed_dial_screens/start_workout_shortcut_screen.dart';

import '../../constants.dart';
import 'announcement_card.dart';

class AnnouncementCardPageView extends StatefulWidget {
  @override
  _AnnouncementCardPageViewState createState() =>
      _AnnouncementCardPageViewState();
}

class _AnnouncementCardPageViewState extends State<AnnouncementCardPageView> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Timer.periodic(Duration(seconds: 10), (Timer timer) {
    //   if (_currentPage < 1) {
    //     _currentPage++;
    //   } else {
    //     _currentPage = 0;
    //   }

    //   // _pageController.animateToPage(
    //   //   _currentPage,
    //   //   duration: Duration(milliseconds: 350),
    //   //   curve: Curves.easeInOut,
    //   // );
    // });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 3 / 7,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              AnnouncementCard(
                imageUrl: 'assets/images/event_photo_1.png',
                title: S.current.announcementCardTitle1,
                subtitle: S.current.startNow,
                color: Colors.deepPurpleAccent,
                onTap: () => CreateNewRoutineScreen.show(context),
              ),
              AnnouncementCard(
                imageUrl: 'assets/images/event_photo_1.png',
                title: S.current.announcementCardTitle2,
                subtitle: S.current.startNow,
                color: Colors.blueAccent,
                onTap: () => StartWorkoutShortcutScreen.show(context),
              ),
            ],
          ),
          Positioned(
            bottom: 8,
            child: Container(
              height: 20,
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 2,
                effect: const ScrollingDotsEffect(
                  activeDotScale: 1.5,
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: Colors.white30,
                  activeDotColor: PrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
