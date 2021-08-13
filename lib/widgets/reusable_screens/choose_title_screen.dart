import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/main_provider.dart';
// import 'package:workout_player/models/text_field_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';
import 'package:workout_player/widgets/text_field/full_screen_text_text_field_widget.dart';

class ChooseTitleScreen<T> extends StatefulWidget {
  final T model;
  // final TextFieldModel textFieldModel;
  final GlobalKey<FormState> formKey;
  final String appBarTitle;
  final String hintText;

  const ChooseTitleScreen({
    Key? key,
    required this.model,
    // required this.textFieldModel,
    required this.formKey,
    required this.appBarTitle,
    required this.hintText,
  }) : super(key: key);

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
            // textFieldModel: watch(textFieldModelProvider),
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
        brightness: Brightness.dark,
        leading: const AppBarCloseButton(),
        title: Text(widget.appBarTitle, style: TextStyles.subtitle2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: widget.formKey,
        child: FullScreenTextTextFieldWidget(
          controller: widget.model.textEditingController,
          formKey: widget.formKey,
          // model: widget.textFieldModel,
          hintText: widget.hintText,
          customValidator: widget.model.validator,
          maxLength: 45,
          maxLines: 1,
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
