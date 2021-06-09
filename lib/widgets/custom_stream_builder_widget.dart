import 'package:flutter/material.dart';

import 'empty_content.dart';

typedef HasDataWidget<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot);

class CustomStreamBuilderWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final T? initialData;
  final HasDataWidget<T> hasDataWidget;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const CustomStreamBuilderWidget({
    Key? key,
    required this.stream,
    required this.hasDataWidget,
    this.errorWidget,
    this.initialData,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return hasDataWidget(context, snapshot);
        } else if (snapshot.hasError) {
          return errorWidget ?? EmptyContent();
        }
        return loadingWidget ?? Center(child: CircularProgressIndicator());
      },
    );
  }
}