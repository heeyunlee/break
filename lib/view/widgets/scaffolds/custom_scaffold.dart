import 'package:flutter/material.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../widgets.dart';
import 'appbar_blur_bg.dart';

///
/// Creates a custom Scaffold widget with some pre-determined styles.
///
/// [extendBodyBehindAppBar] = `true`
///
/// [backgroundColor] = `kBackgroundColor`
///
/// AppBar's [centerTitle] = `true`
///
/// AppBar's [brightness] = `Brightness.dark`
///
/// AppBar's [backgroundColor] = `Colors.transparent`
///
/// AppBar's [flexibleSpace] = `AppbarBlurBG()`
///
/// AppBar's title Style
class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    this.appBarLeading,
    this.appBarActions,
    this.appBarTitle,
    required this.buildBody,
    this.fabWidget,
  }) : super(key: key);

  /// AppBar's leading widget. Default is [AppBarBackButton]
  final Widget? appBarLeading;

  /// AppBar's Title String. Default is '' with the style of [TextStyles.subtitle2]
  final String? appBarTitle;

  /// AppBar's Action widgets. Default is `null`
  final List<Widget>? appBarActions;

  /// builder for body widget. Used [Builder] function so that the scaffold can
  /// be extended behind AppBar and body can access `Scaffold.of(context)`
  final Widget Function(BuildContext) buildBody;

  /// FAB for the scaffold. Default is `null`
  final Widget? fabWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        leading: appBarLeading ?? const AppBarBackButton(),
        actions: appBarActions,
        flexibleSpace: const AppbarBlurBG(),
        title: Text(appBarTitle ?? '', style: TextStyles.subtitle2),
      ),
      body: Builder(
        builder: (BuildContext context) => buildBody(context),
      ),
      floatingActionButton: fabWidget,
    );
  }
}
