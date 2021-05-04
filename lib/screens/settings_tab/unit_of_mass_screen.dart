import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';

Logger logger = Logger();

class UnitOfMassScreen extends StatefulWidget {
  const UnitOfMassScreen({
    Key key,
    @required this.database,
    @required this.user,
    @required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show({BuildContext context, User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => UnitOfMassScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _UnitOfMassScreenState createState() => _UnitOfMassScreenState();
}

class _UnitOfMassScreenState extends State<UnitOfMassScreen> {
  int _unitOfMass;

  @override
  void initState() {
    super.initState();
    _unitOfMass = widget.user.unitOfMass;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _updateUnitOfMass() async {
    try {
      final user = {
        'unitOfMass': _unitOfMass,
      };
      await widget.database.updateUser(widget.auth.currentUser.uid, user);
      debugPrint('Updated Unit Of Mass');
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
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        title: Text(S.current.unitOfMass, style: Subtitle1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          tileColor: (_unitOfMass == 0) ? Primary600Color : Colors.transparent,
          title: const Text('kg', style: BodyText1),
          trailing: (_unitOfMass == 0)
              ? const Icon(Icons.check, color: Colors.white)
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
          title: const Text('lbs', style: BodyText1),
          trailing: (_unitOfMass == 1)
              ? const Icon(Icons.check, color: Colors.white)
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
