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
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/database.dart';

class EditUnitOfMassScreen extends StatefulWidget {
  const EditUnitOfMassScreen({
    Key? key,
    required this.routine,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static Future<void> show(
    BuildContext context, {
    required User user,
    required Routine routine,
  }) async {
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
  late int _unitOfMass;

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

      getSnackbarWidget(
        S.current.unitOfMass,
        S.current.updateUnitOfMassMessage(S.current.routine),
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
        backgroundColor: Colors.transparent,
        title: Text(S.current.unitOfMass, style: TextStyles.subtitle1),
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
          tileColor: (_unitOfMass == 0) ? kPrimary600Color : Colors.transparent,
          title: const Text('kg', style: TextStyles.body1),
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
          tileColor: (_unitOfMass == 1) ? kPrimary600Color : Colors.transparent,
          title: const Text('lbs', style: TextStyles.body1),
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
