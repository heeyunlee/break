import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/change_display_name_screen_model.dart';

class ChangeDisplayNameScreen extends StatefulWidget {
  const ChangeDisplayNameScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ChangeDisplayNameScreenModel model;

  static Future<void> show(BuildContext context, {required User user}) async {
    customPush(
      context,
      rootNavigator: true,
      builder: (context, auth, database) => Consumer(
        builder: (context, watch, child) {
          return ChangeDisplayNameScreen(
            model: watch(changeDisplayNameScreenModelProvider(user)),
          );
        },
      ),
    );
  }

  @override
  _ChangeDisplayNameScreenState createState() =>
      _ChangeDisplayNameScreenState();
}

class _ChangeDisplayNameScreenState extends State<ChangeDisplayNameScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.current.editDisplayNameTitle,
          style: TextStyles.subtitle1,
        ),
        leading: const AppBarCloseButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: ChangeDisplayNameScreenModel.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            child: UnderlinedTextTextFieldWidget(
              autoFocus: true,
              inputStyle: TextStyles.headline5,
              textAlign: TextAlign.center,
              maxLength: 30,
              hintStyle: TextStyles.headline6Grey,
              hintText: S.current.displayNameHintText,
              counterStyle: TextStyles.caption1Grey,
              focusNode: widget.model.focusNode,
              controller: widget.model.textController,
              formKey: ChangeDisplayNameScreenModel.formKey,
              onFieldSubmitted: (value) => widget.model.onFieldSubmitted(
                context,
                value,
              ),
            ),
          ),
          Text(S.current.yourDisplayName, style: TextStyles.body1Grey),
        ],
      ),
    );
  }
}
