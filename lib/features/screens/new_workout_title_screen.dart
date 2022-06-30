import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/features/widgets/dialogs.dart';

class NewWorkoutTitleScreen extends StatefulWidget {
  final StringCallback titleCallback;
  final IntCallback indexCallback;

  const NewWorkoutTitleScreen({
    Key? key,
    required this.titleCallback,
    required this.indexCallback,
  }) : super(key: key);

  @override
  State<NewWorkoutTitleScreen> createState() => _NewWorkoutTitleScreenState();
}

class _NewWorkoutTitleScreenState extends State<NewWorkoutTitleScreen> {
  late String? _workoutTitle;
  late TextEditingController _textController1;

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _workoutTitle = null;
    _textController1 = TextEditingController(text: _workoutTitle);
  }

  @override
  void dispose() {
    _textController1.dispose();
    super.dispose();
  }

  void saveTitle() {
    if (_workoutTitle != null && _workoutTitle != '') {
      setState(() {
        _pageIndex = 1;
        widget.indexCallback(_pageIndex);
      });
    } else {
      showAlertDialog(
        context,
        title: S.current.workoutTitleAlertTitle,
        content: S.current.workoutTitleAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          maxLength: 35,
          style: TextStyles.headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          controller: _textController1,
          decoration: InputDecoration(
            counterStyle: TextStyles.caption1,
            hintStyle: TextStyles.headline6Grey,
            hintText: S.current.workoutHintText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.secondary),
            ),
          ),
          onChanged: (value) => setState(() {
            _workoutTitle = value;
            widget.titleCallback(_workoutTitle!);
          }),
          onSaved: (value) => setState(() {
            _workoutTitle = value;
            widget.titleCallback(_workoutTitle!);
          }),
          onFieldSubmitted: (value) => setState(() {
            _workoutTitle = value;
            widget.titleCallback(_workoutTitle!);
            saveTitle();
          }),
        ),
      ),
    );
  }
}
