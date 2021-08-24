import 'package:flutter/material.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

// COLOR //
// Primary

const kPrimary900Color = Color(0xff6c1f12);
const kPrimary800Color = Color(0xff852616);
const kPrimary700Color = Color(0xffa6301b);
const kPrimary600Color = Color(0xffc73a20);
const kPrimaryColor = Color(0xffdd4124);
const kPrimary400Color = Color(0xffe77966);
const kPrimary300Color = Color(0xfff1b3a7);
const kPrimary200Color = Color(0xfff7cfc8);
const kPrimary100Color = Color(0xfffcece9);

// Secondary
const kSecondaryColor = Color(0xff24c0dd);

// Grey
const kGrey900 = Color(0xff121212);
const kGrey800 = Color(0xff303030);
const kGrey700 = Color(0xff4d4d4d);
const kGrey600 = Color(0xff6b6b6b);
const kPrimaryGrey = Color(0xff898989);
const kGrey400 = Color(0xffa6a6a6);
const kGrey300 = Color(0xffc4c4c4);
const kGrey200 = Color(0xffe1e1e1);
const kGrey100 = Color(0xffffffff);

const kKeyboardDarkColor = Color(0xff303030);
const kBackgroundColor = Color(0xff121212);
const kAppBarColor = Color(0xff1C1C1C);
const kCardColor = Color(0xff242526);
const kCardColorLight = Color(0xff3C3C3C);
const kCardColorSuperLight = Color(0xff666666);
const kButtonEnabledColor = Color(0xff4E4F50);
const kDisabledColor = Color(0xff9A9EA6);
const kFocusedColor = Color(0xff605350);
const kBottomNavBarColor = Color(0xff1C1C1C);

// OTHERS //
const kCustomDivider = Divider(
  color: kGrey700,
  height: 48,
);

const kCustomDividerIndent16 = Divider(
  color: kGrey700,
  indent: 16,
  endIndent: 16,
);

const kCustomDividerIndent8 = Divider(
  color: kGrey700,
  indent: 8,
  endIndent: 8,
);

const kPrimaryColorCircularProgressIndicator = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
);

const kBicepEmojiUrl =
    'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/flexed-biceps_1f4aa.png';

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
