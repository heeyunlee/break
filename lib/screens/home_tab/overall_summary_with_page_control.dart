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
                title: '총 들어올린 무게',
                summary: '1.2 T',
                subtitle: '꼬끼리를 12번 들어올린것과 같아요!',
              ),
              // _buildPage(),
              CardPageWidget(
                color: Colors.purpleAccent,
                title: '아직 들어올린 무게가 없습니다...',
                summary: '0 Kg',
                subtitle: 'at vehicula purus sagittis',
              ),
              // CardPageWidget(
              //   color: Colors.cyan,
              //   title: '아직 들어올린 무게가 없습니다...',
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

  Widget _buildPage() {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 1,
      color: Colors.purpleAccent,
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            'Off to the Great Start!',
            style: BodyText2,
          ),
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Mon', style: Subtitle2),
                  SizedBox(height: 4),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Keep it up!',
            style: BodyText2,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
