import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view_models/main_model.dart';

import '../basic.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    this.errorWidget,
    this.initialData,
    this.loadingWidget,
    this.emptyWidget,
  }) : super(key: key);

  final Stream<T> stream;
  final T? initialData;
  final SnapshotActiveBuilder<T> builder;

  /// A widget to be shown when snapshot returns error.
  ///
  /// Default is [EmptyContent] widget with errorOccuredMessage and error.
  ///
  final Widget? errorWidget;

  /// A widget to be shown when sapshot connection state is [ConnectionState.none],
  /// [ConnectionState.waiting], or [ConnectionState.done].
  ///
  /// Default widget is [CircularProgressIndicator] with color of [kPrimaryColor]
  ///
  final Widget? loadingWidget;

  /// A widget io be shown when `snapshot.data == null`.
  ///
  /// Default is [EmptyContent]
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          logger.e(snapshot.error);

          return errorWidget ??
              EmptyContent(
                message: S.current.errorOccuredMessage,
                e: snapshot.error,
              );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.done:
              return loadingWidget ??
                  const Center(child: kPrimaryColorCircularProgressIndicator);
            case ConnectionState.active:
              final data = snapshot.data;
              if (data != null) {
                return builder(context, data);
              } else {
                return emptyWidget ??
                    EmptyContent(message: S.current.emptyContentTitle);
              }
          }
        }
      },
    );
  }
}
