import 'package:flutter/material.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final SnapshotActiveBuilder<T> builder;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const CustomFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.errorWidget,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!);
        } else if (snapshot.hasError) {
          logger.e(snapshot.error);

          return errorWidget ??
              const ListTile(
                leading: Icon(
                  Icons.error_outline_outlined,
                  color: Colors.white,
                ),
              );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
