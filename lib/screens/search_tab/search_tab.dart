import 'package:flutter/material.dart';

import '../../constants.dart';
import 'announcement_card_page_view.dart';
import 'search_tab_body_widget.dart';

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: AppBarColor,
              expandedHeight: size.height * 3 / 7,
              flexibleSpace: FlexibleSpaceBar(
                background: AnnouncementCardPageView(),
              ),
            ),
          ];
        },
        body: SearchTabBodyWidget(),
      ),
    );
  }
}
