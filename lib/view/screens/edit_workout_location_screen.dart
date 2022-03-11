import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

class EditWorkoutLocationScreen extends ConsumerStatefulWidget {
  const EditWorkoutLocationScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final Workout workout;

  static void show(
    BuildContext context, {
    required Workout workout,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => EditWorkoutLocationScreen(
        workout: workout,
      ),
    );
  }

  @override
  _EditWorkoutLocationScreenState createState() =>
      _EditWorkoutLocationScreenState();
}

class _EditWorkoutLocationScreenState
    extends ConsumerState<EditWorkoutLocationScreen> {
  late String _location;

  @override
  void initState() {
    _location = widget.workout.location;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _updateLocation() async {
    try {
      final workout = {
        'location': _location,
      };
      final database = ref.watch<Database>(databaseProvider);
      await database.updateWorkout(widget.workout, workout);

      getSnackbarWidget(
        S.current.updateLocationTitle,
        S.current.updateLocationMessage(S.current.workout),
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.location, style: TextStyles.subtitle1),
        leading: const AppBarBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        ListTile(
          tileColor: (_location == Location.atHome.toString())
              ? theme.primaryColorDark
              : Colors.transparent,
          title: Text(Location.atHome.translation!, style: TextStyles.body1),
          trailing: (_location == Location.atHome.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.atHome.toString();
            });
            _updateLocation();
          },
        ),
        ListTile(
          tileColor: (_location == Location.gym.toString())
              ? theme.primaryColorDark
              : Colors.transparent,
          title: Text(Location.gym.translation!, style: TextStyles.body1),
          trailing: (_location == Location.gym.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.gym.toString();
            });
            _updateLocation();
          },
        ),
        ListTile(
          tileColor: (_location == Location.outdoor.toString())
              ? theme.primaryColorDark
              : Colors.transparent,
          title: Text(Location.outdoor.translation!, style: TextStyles.body1),
          trailing: (_location == Location.outdoor.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.outdoor.toString();
            });
            _updateLocation();
          },
        ),
        ListTile(
          tileColor: (_location == Location.others.toString())
              ? theme.primaryColorDark
              : Colors.transparent,
          title: Text(Location.others.translation!, style: TextStyles.body1),
          trailing: (_location == Location.others.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.others.toString();
            });
            _updateLocation();
          },
        ),
      ],
    );
  }
}
