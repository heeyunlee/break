import 'package:flutter/material.dart';

import '../constants.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppBarColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
