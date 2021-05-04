import 'package:flutter/material.dart';
import 'package:workout_player/widgets/speed_dial_fab.dart';

import '../../constants.dart';
import 'announcement_card_page_view.dart';
import 'search_tab_body_widget.dart';

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('SearchTab scaffold building...');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              brightness: Brightness.dark,
              backgroundColor: AppBarColor,
              expandedHeight: size.height * 3.5 / 7,
              flexibleSpace: FlexibleSpaceBar(
                background: AnnouncementCardPageView(),
              ),
            ),
          ];
        },
        body: SearchTabBodyWidget(),
      ),
      floatingActionButton: SpeedDialFAB(),
    );
  }
}
