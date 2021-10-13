import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/dialogs.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

class EditWorkoutLocationScreen extends StatefulWidget {
  const EditWorkoutLocationScreen({
    Key? key,
    required this.workout,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Workout workout;
  final Database database;
  final User user;

  static Future<void> show(
    BuildContext context, {
    required User user,
    required Workout workout,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditWorkoutLocationScreen(
          database: database,
          user: user,
          workout: workout,
        ),
      ),
    );
  }

  @override
  _EditWorkoutLocationScreenState createState() =>
      _EditWorkoutLocationScreenState();
}

class _EditWorkoutLocationScreenState extends State<EditWorkoutLocationScreen> {
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
      await widget.database.updateWorkout(widget.workout, workout);

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
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.location, style: TextStyles.subtitle1),
        leading: const AppBarBackButton(),
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          tileColor: (_location == Location.atHome.toString())
              ? ThemeColors.primary600
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
              ? ThemeColors.primary600
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
              ? ThemeColors.primary600
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
              ? ThemeColors.primary600
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