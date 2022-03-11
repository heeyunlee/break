import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';

class CustomStreamBuilderNew<T> extends StatelessWidget {
  const CustomStreamBuilderNew({
    Key? key,
    required this.stream,
    required this.builder,
    required this.errorBuilder,
    required this.loadingBuilder,
    required this.emptyWidgetBuilder,
    this.initialData,
  }) : super(key: key);

  ///
  final Stream<T> stream;

  ///
  final T? initialData;

  ///
  final SnapshotActiveBuilder<T> builder;

  /// A builder for a widget when the error occurrs
  final Widget Function(BuildContext context, Object e) errorBuilder;

  /// A widget to be shown when sapshot connection state is [ConnectionState.none],
  /// [ConnectionState.waiting], or [ConnectionState.done].
  ///
  /// Default widget is [CircularProgressIndicator] with color of `Theme.of(context).primaryColor`
  ///
  final Widget Function(BuildContext context) loadingBuilder;

  /// A widget io be shown when `snapshot.data == null`.
  ///
  final Widget Function(BuildContext context) emptyWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      key: key,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return errorBuilder(context, snapshot.error!);
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.done:
              return loadingBuilder(context);
            case ConnectionState.active:
              final data = snapshot.data;

              if (data != null) {
                return builder(context, data);
              } else {
                return emptyWidgetBuilder(context);
              }
          }
        }
      },
    );
  }
}
