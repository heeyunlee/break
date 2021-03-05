import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/screens/library_tab/routine/create_routine/create_new_routine_screen.dart';
import 'package:workout_player/screens/search_tab/start_workout_shortcut_screen.dart';

import '../../constants.dart';
import 'announcement_card.dart';

class AnnouncementCardPageView extends StatefulWidget {
  @override
  _AnnouncementCardPageViewState createState() =>
      _AnnouncementCardPageViewState();
}

class _AnnouncementCardPageViewState extends State<AnnouncementCardPageView> {
  // int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  // @override
  // void initState() {
  //   super.initState();
  //   Timer.periodic(Duration(seconds: 10), (Timer timer) {
  //     if (_currentPage < 1) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }

  //     _pageController.animateToPage(
  //       _currentPage,
  //       duration: Duration(milliseconds: 350),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Container(
          height: size.height * 2 / 7,
          child: PageView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              AnnouncementCard(
                child: Image.asset(
                  'assets/images/event_card_1.png',
                  fit: BoxFit.cover,
                ),
                onTap: () => CreateNewRoutineScreen.show(context),
              ),
              AnnouncementCard(
                child: Image.asset(
                  'assets/images/event_card_2.png',
                  fit: BoxFit.cover,
                ),
                onTap: () => StartWorkoutShortcutScreen.show(context),
              ),
            ],
          ),
        ),
        Container(
          height: 20,
          alignment: Alignment.center,
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: const ScrollingDotsEffect(
              activeDotScale: 1.5,
              dotHeight: 8,
              dotWidth: 8,
              dotColor: Grey700,
              activeDotColor: PrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
