import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants.dart';
import 'app_preview_widget.dart';
import 'sign_in_screen.dart';

class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: BackgroundColor,
      body: _buildPreviewScreen(context),
    );
  }

  Widget _buildPreviewScreen(BuildContext context) {
    final controller = PageController();

    return Stack(
      children: [
        PageView(
          controller: controller,
          children: <Widget>[
            // TODO: Add previews of the app
            AppPreviewWidget(),
            AppPreviewWidget(),
            AppPreviewWidget(),
            AppPreviewWidget(),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: ScrollingDotsEffect(
                  activeDotColor: PrimaryColor,
                  activeDotScale: 1.5,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 10,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Tooltip(
                  message: '시작하기',
                  child: RaisedButton(
                    color: PrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 48,
                      width: 258,
                      child: Center(
                        child: Text(
                          '시작하기',
                          style: BodyText2,
                        ),
                      ),
                    ),
                    onPressed: () {
                      return SignInScreen.create(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
