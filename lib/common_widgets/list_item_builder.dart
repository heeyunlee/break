import 'package:flutter/material.dart';
import 'package:workout_player/common_widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.emptyContentTitle,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String emptyContentTitle;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      print(snapshot.error);
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent(
          message: emptyContentTitle,
        );
      }
    } else if (snapshot.hasError) {
      print(snapshot.error);
      return EmptyContent(
        message: 'Something went wrong',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(
        context,
        items[index],
      ),
    );
  }
}
