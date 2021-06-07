import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class SliverAppBarDelegateTabBar extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegateTabBar(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: kAppBarColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegateTabBar oldDelegate) {
    return false;
  }
}
