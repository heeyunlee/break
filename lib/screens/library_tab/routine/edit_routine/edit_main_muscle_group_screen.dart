import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditMainMuscleGroupScreen extends StatefulWidget {
  const EditMainMuscleGroupScreen({
    Key key,
    this.routine,
    this.database,
    this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditMainMuscleGroupScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditMainMuscleGroupScreenState createState() =>
      _EditMainMuscleGroupScreenState();
}

class _EditMainMuscleGroupScreenState extends State<EditMainMuscleGroupScreen> {
  MainMuscleGroup _mainMuscleGroup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < MainMuscleGroup.values.length; i++) {
      if (MainMuscleGroup.values[i].label == widget.routine.mainMuscleGroup)
        _mainMuscleGroup = MainMuscleGroup.values[i];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateMainMuscleGroup() async {
    // Get Image Url
    try {
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final String label = _mainMuscleGroup.label;
      final imageIndex = Random().nextInt(2);
      final imageUrl =
          await ref.child('$label$imageIndex.jpeg').getDownloadURL();

      final routine = {
        'imageUrl': imageUrl,
        'mainMuscleGroup': _mainMuscleGroup.label,
      };

      await widget.database.updateRoutine(widget.routine, routine);
    } on Exception catch (e) {
      logger.d(e);
      ShowExceptionAlertDialog(
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Main Muscle Group', style: Subtitle1),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.grey,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MainMuscleGroup.values.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 56,
                      color: Grey700,
                      child: RadioListTile<MainMuscleGroup>(
                        title: Text(
                          '${MainMuscleGroup.values[index].label}',
                          style: ButtonText,
                        ),
                        activeColor: PrimaryColor,
                        value: MainMuscleGroup.values[index],
                        groupValue: _mainMuscleGroup,
                        onChanged: (MainMuscleGroup value) {
                          setState(() {
                            _mainMuscleGroup = value;
                            debugPrint('${_mainMuscleGroup.label}');
                            updateMainMuscleGroup();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
