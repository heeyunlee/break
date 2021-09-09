import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../styles/constants.dart';

class UnitOfMassScreen extends StatefulWidget {
  const UnitOfMassScreen({
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
  late int _unitOfMass;
  late UnitOfMass? _unitOfMassEnum;

  @override
  void initState() {
    super.initState();
    _unitOfMass = widget.user.unitOfMass ?? 0;
    _unitOfMassEnum = widget.user.unitOfMassEnum;
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
        'unitOfMassEnum': EnumToString.convertToString(_unitOfMassEnum),
      };
      await widget.database.updateUser(widget.auth.currentUser!.uid, user);

      getSnackbarWidget(
        S.current.unitOfMass,
        S.current.updateUnitOfMassUserMessage,
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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.unitOfMass, style: TextStyles.subtitle1),
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
          tileColor: (_unitOfMass == 0) ? kPrimary600Color : Colors.transparent,
          title: const Text('kg', style: TextStyles.body1),
          trailing: (_unitOfMass == 0)
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _unitOfMass = 0;
              _unitOfMassEnum = UnitOfMass.kilograms;
            });
            _updateUnitOfMass();
          },
        ),
        ListTile(
          tileColor: (_unitOfMass == 1) ? kPrimary600Color : Colors.transparent,
          title: const Text('lbs', style: TextStyles.body1),
          trailing: (_unitOfMass == 1)
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _unitOfMass = 1;
              _unitOfMassEnum = UnitOfMass.pounds;
            });
            _updateUnitOfMass();
          },
        ),
      ],
    );
  }
}
