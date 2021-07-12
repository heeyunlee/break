import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/empty_content.dart';

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.emptyContentTitle = 'No Contents....',
    this.emptyContentButton,
    this.isEmptyContentWidget = false,
    this.emptyContentWidget,
    this.scrollController,
  }) : super(key: key);

  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;
  final String emptyContentTitle;
  final Widget? emptyContentButton;
  final bool isEmptyContentWidget;
  final Widget? emptyContentWidget;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return _buildList(items);
    } else {
      if (!isEmptyContentWidget) {
        return EmptyContent(
          message: emptyContentTitle,
          button: emptyContentButton,
        );
      }
      return emptyContentWidget ?? Container();
    }
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(
        context,
        items[index],
      ),
    );
  }
}
