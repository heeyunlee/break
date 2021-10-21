import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';

bool? customPush(
  BuildContext context, {
  required bool rootNavigator,
  required CustomNavigatorBuilder builder,
}) {
  final container = ProviderContainer();
  final auth = container.read(authServiceProvider);
  final database = container.read(databaseProvider(auth.currentUser?.uid));

  HapticFeedback.mediumImpact();

  Navigator.of(context, rootNavigator: rootNavigator).push(
    Platform.isIOS
        ? CupertinoPageRoute(
            fullscreenDialog: rootNavigator,
            builder: (context) => builder(context, auth, database),
          )
        : MaterialPageRoute(
            fullscreenDialog: rootNavigator,
            builder: (context) => builder(context, auth, database),
          ),
  );
}
