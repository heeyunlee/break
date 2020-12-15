import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants.dart';

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
                    Expanded(
                      child: Center(
                        child: Image.network(
                          'https://images.squarespace-cdn.com/content/v1/54d4f56de4b0ab3240fa8693/1475073802933-1S98QQSXCOY0OVBJIUOO/ke17ZwdGBToddI8pDm48kDHPSfPanjkWqhH6pl6g5ph7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0mwONMR1ELp49Lyc52iWr5dNb1QJw9casjKdtTg1_-y4jz4ptJBmI9gQmbjSQnNGng/image-asset.jpeg',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                    Text('아직 들어올린 무게가 없습니다.', style: BodyText2),
                    SizedBox(height: 16),
                  ],
                ),
                // child: Column(
                //   children: [
                //     SizedBox(height: 8),
                //     Text(
                //       '아직 들어올린 무게가 없습니다',
                //       style: BodyText2,
                //     ),
                //     SizedBox(height: 8),
                //     Text(
                //       '7000kg',
                //       style: Headline1,
                //     ),
                //     Spacer(),
                //     Text(
                //       'sdsd',
                //       style: BodyText2,
                //     ),
                //     SizedBox(height: 8),
                //   ],
                // ),
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
                        style: Headline3,
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
                        style: Headline3,
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
                        style: Headline3,
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
