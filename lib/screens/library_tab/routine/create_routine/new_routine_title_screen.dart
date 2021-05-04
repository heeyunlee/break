import 'package:flutter/material.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../../constants.dart';

typedef StringCallback = void Function(String title);
typedef IntCallback = void Function(int index);

class NewRoutineTitleScreen extends StatefulWidget {
  final StringCallback titleCallback;
  final IntCallback indexCallback;

  const NewRoutineTitleScreen({Key key, this.titleCallback, this.indexCallback})
      : super(key: key);

  @override
  _NewRoutineTitleScreenState createState() => _NewRoutineTitleScreenState();
}

class _NewRoutineTitleScreenState extends State<NewRoutineTitleScreen> {
  String _routineTitle;
  var _textController1 = TextEditingController();

  int _pageIndex = 0;

  @override
  void initState() {
    _routineTitle = null;
    _textController1 = TextEditingController(text: _routineTitle);
    super.initState();
  }

  @override
  void dispose() {
    _textController1.dispose();
    super.dispose();
  }

  void saveTitle() {
    debugPrint('saveTitle Pressed');
    if (_routineTitle != null && _routineTitle != '') {
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
          style: Headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          controller: _textController1,
          decoration: InputDecoration(
            counterStyle: Caption1,
            hintStyle: SearchBarHintStyle,
            hintText: S.current.routineTitleHintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: PrimaryColor),
            ),
          ),
          onChanged: (value) => setState(() {
            _routineTitle = value;
            widget.titleCallback(_routineTitle);
          }),
          onSaved: (value) => setState(() {
            _routineTitle = value;
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
