import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants.dart';

class WorkoutSummaryWithPageControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    return Column(
      children: [
        Container(
          height: 416,
          child: PageView(
            controller: controller,
            children: [
              Card(
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 1,
                color: Colors.white12,
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '오늘 들어올린 무게',
                      style: BodyText2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '7000kg',
                      style: Headline1,
                    ),
                    Spacer(),
                    Text(
                      'sdsd',
                      style: BodyText2,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                  color: Colors.blue,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        '오늘 들어올린 무게',
                        style: BodyText2,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '7000kg',
                        style: Headline1,
                      ),
                      Spacer(),
                      Text(
                        'sdsd',
                        style: BodyText2,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                  color: Colors.brown,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        '오늘 들어올린 무게',
                        style: BodyText2,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '7000kg',
                        style: Headline1,
                      ),
                      Spacer(),
                      Text(
                        'sdsd',
                        style: BodyText2,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                  color: Colors.deepPurpleAccent,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        '오늘 들어올린 무게',
                        style: BodyText2,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '7000kg',
                        style: Headline1,
                      ),
                      Spacer(),
                      Text(
                        'sdsd',
                        style: BodyText2,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 20,
          alignment: Alignment.center,
          child: SmoothPageIndicator(
            controller: controller,
            count: 4,
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
