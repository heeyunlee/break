import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

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
    final container = ProviderContainer();
    final auth = container.read(authServiceProvider);
    final database = container.read(databaseProvider(auth.currentUser?.uid));

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
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
        final List<Map<String, dynamic>> routineHistories = [];
        final historiesDoc =
            await widget.database.routineHistoriesStream().first;
        if (historiesDoc.isNotEmpty) {
          // TODO: refactor here: avoid_function_literals_in_foreach_calls
          // ignore: avoid_function_literals_in_foreach_calls
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

        logger.d('Updated Display Name');

        getSnackbarWidget(
          S.current.updateDisplayNameSnackbarTitle,
          S.current.updateDisplayNameSnackbar,
        );
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
        title: Text(
          S.current.editDisplayNameTitle,
          style: TextStyles.subtitle1,
        ),
        leading: const AppBarCloseButton(),
        flexibleSpace: const AppbarBlurBG(),
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
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            style: TextStyles.headline5,
            autofocus: true,
            textAlign: TextAlign.center,
            controller: _textController1,
            maxLength: 25,
            decoration: InputDecoration(
              hintStyle: TextStyles.headline6Grey,
              hintText: S.current.displayNameHintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
              counterStyle: TextStyles.caption1Grey,
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
        Text(S.current.yourDisplayName, style: TextStyles.body1Grey),
      ],
    );
  }
}
