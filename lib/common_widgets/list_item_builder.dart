import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:workout_player/common_widgets/empty_content.dart';

Logger logger = Logger();

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.emptyContentTitle = 'No Contents....',
    this.emptyContentButton,
    this.isEmptyContentWidget = false,
    this.emptyContentWidget,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String emptyContentTitle;
  final Widget emptyContentButton;
  final bool isEmptyContentWidget;
  final Widget emptyContentWidget;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        if (!isEmptyContentWidget) {
          return EmptyContent(
            message: emptyContentTitle,
            button: emptyContentButton,
          );
        }
        return emptyContentWidget;
      }
    } else if (snapshot.hasError) {
      logger.d(snapshot.error);
      return const EmptyContent(
        message: 'Something went wrong',
      );
    }
    return Center(child: CircularProgressIndicator());
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
