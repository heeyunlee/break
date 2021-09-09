import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

/// Reusable screen that can start the progress of creating either custom [Routine]
/// or [Workout] at the current implementation.
///
/// [T] model must have:
/// * `void Function()` function named [init]
/// * `TextEditingController` getter named [textEditingController]
/// * `String? Function(String?)?` function named [validator]
/// * `void Function(BuildContext, T)` function named [saveTitle]
class ChooseTitleScreen<T> extends StatefulWidget {
  const ChooseTitleScreen({
    Key? key,
    required this.model,
    required this.formKey,
    required this.appBarTitle,
    required this.hintText,
  }) : super(key: key);

  final T model;
  final GlobalKey<FormState> formKey;
  final String appBarTitle;
  final String hintText;

  static void show<T>(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required ProviderBase<ChangeNotifier, T> provider,
    required String appBarTitle,
    required String hintText,
  }) {
    HapticFeedback.mediumImpact();

    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => ChooseTitleScreen<T>(
            formKey: formKey,
            model: watch(provider),
            appBarTitle: appBarTitle,
            hintText: hintText,
          ),
        ),
      ),
    );
  }

  @override
  _ChooseTitleScreenState createState() => _ChooseTitleScreenState();
}

class _ChooseTitleScreenState extends State<ChooseTitleScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('building create new routine scaffold...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: const AppBarCloseButton(),
        title: Text(widget.appBarTitle, style: TextStyles.subtitle2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: widget.formKey,
        child: Center(
          child: Container(
            height: 104,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            child: UnderlinedTextTextFieldWidget(
              controller:
                  widget.model.textEditingController as TextEditingController,
              formKey: widget.formKey,
              hintText: widget.hintText,
              customValidator:
                  widget.model.validator as String? Function(String?)?,
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: () => widget.model.saveTitle(context, widget.model),
      child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
    );
  }
}
