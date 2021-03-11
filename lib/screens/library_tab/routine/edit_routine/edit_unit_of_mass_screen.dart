import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditUnitOfMassScreen extends StatefulWidget {
  const EditUnitOfMassScreen({
    Key key,
    @required this.routine,
    @required this.database,
    @required this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static Future<void> show(
      {BuildContext context, User user, Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditUnitOfMassScreen(
          database: database,
          user: user,
          routine: routine,
        ),
      ),
    );
  }

  @override
  _EditUnitOfMassScreenState createState() => _EditUnitOfMassScreenState();
}

class _EditUnitOfMassScreenState extends State<EditUnitOfMassScreen> {
  int _unitOfMass;

  @override
  void initState() {
    _unitOfMass = widget.routine.initialUnitOfMass;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _updateUnitOfMass() async {
    try {
      final routine = {
        'initialUnitOfMass': _unitOfMass,
      };
      await widget.database.updateRoutine(widget.routine, routine);
      debugPrint('Updated Unit Of Mass');
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Unit of Mass', style: Subtitle1),
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
          tileColor: (_unitOfMass == 0) ? Primary600Color : Colors.transparent,
          title: Text('kg', style: BodyText1),
          trailing: (_unitOfMass == 0)
              ? Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _unitOfMass = 0;
            });
            _updateUnitOfMass();
          },
        ),
        ListTile(
          tileColor: (_unitOfMass == 1) ? Primary600Color : Colors.transparent,
          title: Text('lbs', style: BodyText1),
          trailing: (_unitOfMass == 1)
              ? Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _unitOfMass = 1;
            });
            _updateUnitOfMass();
          },
        ),
      ],
    );
  }
}