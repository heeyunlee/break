import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';

class ChangeDisplayNameScreen extends StatefulWidget {
  const ChangeDisplayNameScreen({
    Key? key,
    required this.database,
    required this.user,
    required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show(BuildContext context, {required User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChangeDisplayNameScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _ChangeDisplayNameScreenState createState() =>
      _ChangeDisplayNameScreenState();
}

class _ChangeDisplayNameScreenState extends State<ChangeDisplayNameScreen> {
  late String _displayName;

  var _textController1 = TextEditingController();
  late FocusNode focusNode1;

  @override
  void initState() {
    _displayName = widget.user.displayName;
    _textController1 = TextEditingController(text: _displayName);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<bool?> _updateDisplayName() async {
    if (_displayName.isNotEmpty) {
      try {
        final user = {
          'displayName': _displayName,
        };
        await widget.database.updateUser(widget.auth.currentUser!.uid, user);

        // Updating username in Routine History
        List<Map<String, dynamic>> routineHistories = [];
        final historiesDoc =
            await widget.database.routineHistoriesStream().first;
        if (historiesDoc.isNotEmpty) {
          historiesDoc.forEach((element) {
            final updatedElement = {
              'routineHistoryId': element.routineHistoryId,
              'username': _displayName,
            };

            routineHistories.add(updatedElement);
          });

          await widget.database.batchUpdateRoutineHistories(routineHistories);
        }

        // TODO: Create Cloud Function that update routineOwner's name
        // // Updating username in Routine
        // List<Map<String, dynamic>> routines = [];
        // final routinesDoc = await widget.database.userRoutinesStream().first;
        // print('length is ${routinesDoc.length}');
        // if (routinesDoc.isNotEmpty) {
        //   print('routines is not empty and length is ${routinesDoc.length}');

        //   routinesDoc.forEach((element) {
        //     final routine = {
        //       'routineId': element.routineId,
        //       'routineOwnerUserName': _displayName,
        //     };
        //     routines.add(routine);
        //   });
        //   await widget.database.batchUpdateRoutines(routines);
        // }

        // TODO: Create Cloud Function that update workoutOwner's name
        // // Updating username in Workout
        // List<Map<String, dynamic>> workouts = [];
        // final workoutsDoc = await widget.database.userWorkoutsStream().first;
        // if (workoutsDoc.isNotEmpty) {
        //   workoutsDoc.forEach((element) {
        //     final workout = {
        //       'workoutId': element.workoutId,
        //       'workoutOwnerUserName': _displayName,
        //     };
        //     workouts.add(workout);
        //   });
        //   await widget.database.batchUpdateWorkouts(workouts);
        // }

        debugPrint('Updated Display Name');

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.updateDisplayNameSnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      return showAlertDialog(
        context,
        title: S.current.displayNameEmptyTitle,
        content: S.current.displayNameEmptyContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.editDisplayNameTitle, style: kSubtitle1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            style: kHeadline5,
            autofocus: true,
            textAlign: TextAlign.center,
            controller: _textController1,
            maxLength: 25,
            decoration: InputDecoration(
              hintStyle: kSearchBarHintStyle,
              hintText: S.current.displayNameHintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              counterStyle: kCaption1Grey,
            ),
            onChanged: (value) => setState(() {
              _displayName = value;
            }),
            onSaved: (value) => setState(() {
              _displayName = value!;
            }),
            onFieldSubmitted: (value) {
              setState(() {
                _displayName = value;
              });
              _updateDisplayName();
            },
          ),
        ),
        Text(S.current.yourDisplayName, style: kBodyText1Grey),
      ],
    );
  }
}
