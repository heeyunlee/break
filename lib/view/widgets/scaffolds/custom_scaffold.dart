import 'package:flutter/material.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'appbar_blur_bg.dart';
import '../widgets.dart';

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
  final Widget? appBarLeading;
  final String? appBarTitle;
  final Widget Function(BuildContext) buildBody;
  final Widget? fabWidget;

  const CustomScaffold({
    Key? key,
    this.appBarLeading,
    this.appBarTitle,
    required this.buildBody,
    this.fabWidget,
  }) : super(key: key);

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
