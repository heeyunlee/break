import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';

import '../basic.dart';

class CustomListViewBuilder<T> extends StatelessWidget {
  const CustomListViewBuilder({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.emptyContentTitle = 'No Contents....',
    this.emptyContentButton,
    this.emptyContentWidget,
    this.scrollController,
    this.header = const SizedBox.shrink(),
    this.footer = const SizedBox.shrink(),
  }) : super(key: key);

  final List<T> items;
  final ItemWidgetBuilder2<T> itemBuilder;
  final String emptyContentTitle;
  final Widget? emptyContentButton;
  final Widget? emptyContentWidget;
  final ScrollController? scrollController;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return _buildList(items);
    } else {
      return emptyContentWidget ??
          EmptyContent(
            message: emptyContentTitle,
            button: emptyContentButton,
          );
    }
  }

  Widget _buildList(List<T> items) {
    return Column(
      children: [
        header!,
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(
            context,
            items[index],
            index,
          ),
        ),
        footer!,
      ],
    );
  }
}
