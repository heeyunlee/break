import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';

class UnitOfMassScreen extends ConsumerStatefulWidget {
  const UnitOfMassScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => UnitOfMassScreen(user: user),
    );
  }

  @override
  _UnitOfMassScreenState createState() => _UnitOfMassScreenState();
}

class _UnitOfMassScreenState extends ConsumerState<UnitOfMassScreen> {
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
      final database = ref.watch(databaseProvider);
      await database.updateUser(database.uid!, user);

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.unitOfMass, style: TextStyles.subtitle1),
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
          tileColor:
              (_unitOfMass == 0) ? theme.primaryColor : Colors.transparent,
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
          tileColor:
              (_unitOfMass == 1) ? theme.primaryColor : Colors.transparent,
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
