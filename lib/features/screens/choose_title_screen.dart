import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/features/widgets/widgets.dart';

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
    required ProviderBase<T> provider,
    required String appBarTitle,
    required String hintText,
  }) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) => ChooseTitleScreen<T>(
          formKey: formKey,
          model: ref.watch(provider),
          appBarTitle: appBarTitle,
          hintText: hintText,
        ),
      ),
    );
  }

  @override
  State<ChooseTitleScreen> createState() => _ChooseTitleScreenState();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const AppBarCloseButton(),
        title: Text(widget.appBarTitle, style: TextStyles.subtitle2),
        centerTitle: true,
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
              validator: widget.model.validator as String? Function(String?)?,
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => widget.model.saveTitle(context, widget.model),
      child: const Icon(Icons.arrow_forward_rounded),
    );
  }
}
