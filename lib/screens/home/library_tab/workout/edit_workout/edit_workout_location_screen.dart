import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.location, style: kSubtitle1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          tileColor: (_location == Location.atHome.toString())
              ? kPrimary600Color
              : Colors.transparent,
          title: Text(Location.atHome.translation!, style: TextStyles.body1),
          trailing: (_location == Location.atHome.toString())
              ? Icon(Icons.check, color: Colors.white)
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
              ? kPrimary600Color
              : Colors.transparent,
          title: Text(Location.gym.translation!, style: TextStyles.body1),
          trailing: (_location == Location.gym.toString())
              ? Icon(Icons.check, color: Colors.white)
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
              ? kPrimary600Color
              : Colors.transparent,
          title: Text(Location.outdoor.translation!, style: TextStyles.body1),
          trailing: (_location == Location.outdoor.toString())
              ? Icon(Icons.check, color: Colors.white)
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
              ? kPrimary600Color
              : Colors.transparent,
          title: Text(Location.others.translation!, style: TextStyles.body1),
          trailing: (_location == Location.others.toString())
              ? Icon(Icons.check, color: Colors.white)
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
