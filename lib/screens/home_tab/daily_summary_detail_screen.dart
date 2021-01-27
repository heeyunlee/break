import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine_history.dart';

import 'daily_summary_row_widget.dart';

class DailySummaryDetailScreen extends StatefulWidget {
  //
  final int index;
  final RoutineHistory routineHistory;

  const DailySummaryDetailScreen({
    this.index,
    this.routineHistory,
  });

  static void show({
    BuildContext context,
    int index,
    RoutineHistory routineHistory,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => DailySummaryDetailScreen(
          index: index,
          routineHistory: routineHistory,
        ),
      ),
    );
  }

  @override
  _DailySummaryDetailScreenState createState() =>
      _DailySummaryDetailScreenState();
}

class _DailySummaryDetailScreenState extends State<DailySummaryDetailScreen> {
  // For SliverApp to work
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (280 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
  // For SliverApp to work

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final timestamp = widget.routineHistory.workedOutTime;
    final date = timestamp.toDate();
    final formattedDate = '${date.month}월 ${date.day}일';

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: (isShrink == false)
                ? Text('Summary', style: Subtitle1)
                : Text(widget.routineHistory.routineTitle, style: Subtitle1),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(Icons.ios_share),
            //     onPressed: () {},
            //   ),
            //   SizedBox(width: 8),
            // ],
            backgroundColor: Colors.transparent,
            floating: false,
            pinned: true,
            snap: false,
            stretch: true,
            expandedHeight: size.height / 3,
            flexibleSpace: isShrink
                ? AppbarBlurBG()
                : FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/workout-player.appspot.com/o/workout-pictures%2Fincline_bench_press_preview.jpeg?alt=media&token=adcd2a37-6db8-4493-b28e-9c582b3e084c',
                          fit: BoxFit.fitHeight,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.routineHistory.routineTitle,
                                  style: Headline5),
                              SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: Subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 16),
                  DailySummaryRowWidget(
                    weightsLifted: widget.routineHistory.totalWeights,
                    caloriesBurnt: widget.routineHistory.totalCalories,
                    totalDuration: widget.routineHistory.totalDuration,
                  ),
                  SizedBox(height: 32),
                  Divider(
                    endIndent: 8,
                    indent: 8,
                    color: Grey800,
                  ),
                  SizedBox(height: 32),
                  Text('오늘의 루틴', style: Subtitle1),
                  SizedBox(height: 8),
                  // ListView.builder(
                  //   padding: EdgeInsets.all(0),
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemCount: 6,
                  //   itemBuilder: (context, index) => WorkoutMediumCard('스쿼트'),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
