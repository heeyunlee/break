import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';

import 'empty_content.dart';

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
          return hasDataWidget(context, snapshot.data!);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.data);

          return errorWidget ??
              EmptyContent(
                message: S.current.errorOccuredMessage,
                e: snapshot.error,
              );
        }
        return loadingWidget ?? Center(child: CircularProgressIndicator());
      },
    );
  }
}
