import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditWorkoutLocationScreen extends StatefulWidget {
  const EditWorkoutLocationScreen({
    Key key,
    @required this.workout,
    @required this.database,
    @required this.user,
  }) : super(key: key);

  final Workout workout;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context,
      {User user, Workout workout}) async {
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
  String _location;

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
      debugPrint('Updated Location');
    } on FirebaseException catch (e) {
      logger.d(e);
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
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(S.current.location, style: Subtitle1),
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
              ? Primary600Color
              : Colors.transparent,
          title: Text(Location.atHome.translation, style: BodyText1),
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
              ? Primary600Color
              : Colors.transparent,
          title: Text(Location.gym.translation, style: BodyText1),
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
              ? Primary600Color
              : Colors.transparent,
          title: Text(Location.outdoor.translation, style: BodyText1),
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
              ? Primary600Color
              : Colors.transparent,
          title: Text(Location.others.translation, style: BodyText1),
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
