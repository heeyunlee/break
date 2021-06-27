import 'package:flutter/material.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';

class NewRoutineTitleScreen extends StatefulWidget {
  final StringCallback titleCallback;
  final IntCallback indexCallback;

  const NewRoutineTitleScreen({
    Key? key,
    required this.titleCallback,
    required this.indexCallback,
  }) : super(key: key);

  @override
  _NewRoutineTitleScreenState createState() => _NewRoutineTitleScreenState();
}

class _NewRoutineTitleScreenState extends State<NewRoutineTitleScreen> {
  late String _routineTitle;
  var _textController1 = TextEditingController();

  int _pageIndex = 0;

  @override
  void initState() {
    _routineTitle = '';
    _textController1 = TextEditingController(text: _routineTitle);
    super.initState();
  }

  @override
  void dispose() {
    _textController1.dispose();
    super.dispose();
  }

  void saveTitle() {
    logger.d('saveTitle Pressed');

    if (_routineTitle.isNotEmpty) {
      setState(() {
        _pageIndex = 1;
        widget.indexCallback(_pageIndex);
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.noRoutineAlertTitle,
        content: S.current.routineTitleValidatorText,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          maxLines: 1,
          maxLength: 45,
          style: TextStyles.headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          controller: _textController1,
          decoration: InputDecoration(
            counterStyle: kCaption1,
            hintStyle: kSearchBarHintStyle,
            hintText: S.current.routineTitleHintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
          ),
          onChanged: (value) => setState(() {
            _routineTitle = value;
            widget.titleCallback(_routineTitle);
          }),
          onSaved: (value) => setState(() {
            _routineTitle = value!;
            widget.titleCallback(_routineTitle);
          }),
          onFieldSubmitted: (value) => setState(() {
            _routineTitle = value;
            widget.titleCallback(_routineTitle);
            saveTitle();
          }),
        ),
      ),
    );
  }
}
