import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants.dart';
import 'card_page_widget.dart';

class WorkoutSummaryWithPageControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    return Column(
      children: [
        Container(
          height: 424,
          child: PageView(
            controller: controller,
            children: [
              CardPageWidget(
                color: Colors.blueAccent,
                title: 'Total Weights Lifted',
                summary: '1.2 T',
                subtitle: 'Almost as much as lifting elephant 24 times!',
              ),
              // _buildPage(),
              CardPageWidget(
                color: Colors.purpleAccent,
                title: 'Haven\' lifted any weights yet...',
                summary: '0 Kg',
                subtitle: 'at vehicula purus sagittis',
              ),
              // CardPageWidget(
              //   color: Colors.cyan,
              //   title: 'Haven\' lifted any weights yet...',
              //   summary: '0 Kg',
              //   subtitle: 'at vehicula purus sagittis',
              // ),
            ],
          ),
        ),
        Container(
          height: 20,
          alignment: Alignment.center,
          child: SmoothPageIndicator(
            controller: controller,
            count: 2,
            effect: ScrollingDotsEffect(
              activeDotScale: 1.5,
              dotHeight: 8,
              dotWidth: 8,
              dotColor: Colors.white.withOpacity(.3),
              activeDotColor: PrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
