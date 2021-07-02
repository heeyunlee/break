import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';

// typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class HoriListItemBuilder<T> extends StatelessWidget {
  const HoriListItemBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
    required this.isEmptyContentWidget,
    this.emptyContentTitle,
    required this.emptyContentWidget,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String? emptyContentTitle;
  final bool isEmptyContentWidget;
  final Widget emptyContentWidget;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      // print(snapshot.error);
      final items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        if (isEmptyContentWidget) {
          return emptyContentWidget;
        } else {
          return EmptyContent(
            message: emptyContentTitle,
          );
        }
      }
    } else if (snapshot.hasError) {
      // print(snapshot.error);
      return EmptyContent(
        message: S.current.somethingWentWrong,
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
