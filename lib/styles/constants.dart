import 'package:flutter/material.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

const kCustomDivider = Divider(
  color: Colors.white24,
  height: 48,
);

const kWhiteDivider = Divider(
  color: Colors.white,
  height: 48,
);

const kCustomDividerIndent16 = Divider(
  color: Colors.white24,
  indent: 16,
  endIndent: 16,
);

const kCustomDividerIndent8 = Divider(
  color: Colors.white24,
  indent: 8,
  endIndent: 8,
);

const kCustomDividerIndent8Heignt1 = Divider(
  color: Colors.white24,
  indent: 8,
  endIndent: 8,
  height: 1,
);

const kBicepEmojiUrl =
    'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/flexed-biceps_1f4aa.png';
const kEatsTabBGUrl =
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/eats_tab%2Feats_tab_bg.jpg?alt=media&token=b639380f-9bc8-4eca-99de-d365ac54f247';

// Type Def
typedef ListCallback<E> = void Function(List<E> list);
typedef DoubleCallback = Function(double number);
typedef StringCallback = Function(String string);
typedef IntCallback = void Function(int index);
typedef BoolCallback = void Function(bool value);
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);
typedef ItemWidgetBuilder2<T> = Widget Function(
    BuildContext context, T item, int index);

typedef SnapshotActiveBuilder<T> = Widget Function(
    BuildContext context, T data);
typedef ErrorWidgetBuilder = Widget Function(BuildContext context, Object e);

typedef CustomNavigatorBuilder = Widget Function(
  BuildContext context,
  AuthBase auth,
  Database database,
);

typedef AuthAndDatabaseWidget = Widget Function(
  AuthBase auth,
  Database database,
  Widget child,
);
