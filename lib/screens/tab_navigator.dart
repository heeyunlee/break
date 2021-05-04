import 'package:flutter/material.dart';
import 'package:workout_player/screens/tab_item.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final Map<TabItem, WidgetBuilder> widgetBuilder;

  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.tabItem,
    @required this.widgetBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
