import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';

import 'empty_content.dart';

class CustomFutureBuilderWidget<T> extends StatelessWidget {
  final Future<T> future;
  final HasDataWidget<T> hasDataWidget;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const CustomFutureBuilderWidget({
    Key? key,
    required this.future,
    required this.hasDataWidget,
    this.errorWidget,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> future) {
        if (future.hasData) {
          return hasDataWidget(context, future.data!);
        } else if (future.hasError) {
          return errorWidget ??
              EmptyContent(
                message: S.current.errorOccuredMessage,
                e: future.error,
              );
        }
        return loadingWidget ?? Center(child: CircularProgressIndicator());
      },
    );
  }
}
