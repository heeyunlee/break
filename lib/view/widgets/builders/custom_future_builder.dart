import 'package:flutter/material.dart';

import 'package:workout_player/styles/constants.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.errorWidget,
    this.loadingWidget,
    this.emptyWidget,
  }) : super(key: key);

  final Future<T> future;
  final SnapshotActiveBuilder<T> builder;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            return builder(context, data);
          } else {
            return emptyWidget ?? const SizedBox();
          }
        } else if (snapshot.hasError) {
          return errorWidget ??
              const ListTile(
                leading: Icon(
                  Icons.error_outline_outlined,
                  color: Colors.white,
                ),
              );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
