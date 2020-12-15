import 'package:flutter/material.dart';

import '../../constants.dart';

class WorkoutDetailScreen extends StatelessWidget {
  static const routeName = '/workout-detail';

  int index;

  WorkoutDetailScreen(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Grey800,
              floating: true,
              pinned: false,
              snap: false,
              stretch: true,
              expandedHeight: 300,
              flexibleSpace: Hero(
                tag: 'heroTag$index',
                child: Container(
                  child:
                      Image.asset('images/place_holder_workout_playlist.png'),
                ),
              ),
            ),
          ];
        },
        body: Placeholder(),
      ),
    );
  }
}
