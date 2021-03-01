import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import '../../../../models/enum_values.dart';

Logger logger = Logger();

class CreateNewWorkoutScreen extends StatefulWidget {
  const CreateNewWorkoutScreen({
    Key key,
    @required this.database,
    this.auth,
  }) : super(key: key);

  final Database database;
  final AuthBase auth;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateNewWorkoutScreen(
          database: database,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _CreateNewWorkoutScreenState createState() => _CreateNewWorkoutScreenState();
}

class _CreateNewWorkoutScreenState extends State<CreateNewWorkoutScreen> {
  String _workoutTitle;
  String _description;
  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();

  MainMuscleGroup _mainMuscleGroup;

  // Map<String, bool> _secondMuscleGroup = {
  //   'Abductors': false,
  //   'Adductors': false,
  //   'Biceps': false,
  //   'Calves': false,
  //   'Chest': false,
  //   'Forearms': false,
  //   'Glutes': false,
  //   'Hamstring': false,
  //   'Hip Flexors': false,
  //   'IT Band': false,
  //   'Lats': false,
  //   'Lower Back': false,
  //   'Upper Back': false,
  //   'Neck': false,
  //   'Obliques': false,
  //   'Quads': false,
  //   'Shoulders': false,
  //   'Traps': false,
  //   'Triceps': false,
  // };
  // List _selectedSecondMuscleGroup = List();
  Map<String, bool> _equipmentRequired = {
    'Barbell': false,
    'Dumbbell': false,
    'Bodyweight': false,
    'Cable': false,
    'Machine': false,
    'EZ Bar': false,
    'Gym ball': false,
    'Bench': false,
  };
  List _selectedEquipmentRequired = List();

  double _difficultySlider;
  String _difficultySliderLabel;

  double _secondsPerRepSlider;
  String _secondsPerRepSliderLabel;

  int _pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _workoutTitle = null;
    _textController1 = TextEditingController(text: _workoutTitle);

    _description = null;
    _textController2 = TextEditingController(text: _description);

    _difficultySlider = 2;
    _difficultySliderLabel = Difficulty.values[_difficultySlider.toInt()].label;

    _secondsPerRepSlider = 2;
    _secondsPerRepSliderLabel = '$_secondsPerRepSlider seconds';
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    debugPrint('_submit button pressed!');
    try {
      final user = await widget.database
          .userStream(userId: widget.auth.currentUser.uid)
          .first;
      final workoutId = documentIdFromCurrentDate();
      final userId = user.userId;
      final userName = user.userName;
      final lastEditedDate = Timestamp.now();
      final workoutCreatedDate = Timestamp.now();
      final isBodyWeightWorkout =
          (_selectedEquipmentRequired.contains('Bodyweight')) ? true : false;

      // Get Image Url
      final ref = FirebaseStorage.instance.ref().child('workout-pictures');
      final String label = _mainMuscleGroup.label;
      final imageIndex = Random().nextInt(2);
      final imageUrl =
          await ref.child('$label$imageIndex.jpeg').getDownloadURL();

      final workout = Workout(
        workoutId: workoutId,
        workoutOwnerId: userId,
        workoutOwnerUserName: userName,
        workoutTitle: _workoutTitle,
        mainMuscleGroup: _mainMuscleGroup.label,
        secondaryMuscleGroup: null,
        description: _description,
        equipmentRequired: _selectedEquipmentRequired,
        imageUrl: imageUrl,
        isBodyWeightWorkout: isBodyWeightWorkout,
        lastEditedDate: lastEditedDate,
        workoutCreatedDate: workoutCreatedDate,
        difficulty: _difficultySlider.toInt(),
        secondsPerRep: _secondsPerRepSlider.toInt(),
        isPublic: true,
      );
      await widget.database.setWorkout(workout).then(
            (value) => WorkoutDetailScreen.show(
              context,
              isRootNavigation: true,
              workout: workout,
              tag: 'newWorkout-${workout.workoutId}',
            ),
          );
    } on FirebaseException catch (e) {
      logger.d(e);
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  void saveTitle() {
    debugPrint('saveTitle Pressed');
    if (_workoutTitle != null && _workoutTitle != '') {
      setState(() {
        _pageIndex = 1;
      });
    } else {
      showAlertDialog(
        context,
        title: 'No routine title',
        content: 'Give routine a name!',
        defaultActionText: 'OK',
      );
    }
  }

  void saveMainMuscleGroup() {
    debugPrint('saveMainMuscleGroup Pressed');
    setState(() {
      _pageIndex = 2;
    });
  }

  // void saveSecondMuscleGroup() {
  //   debugPrint('saveMainMuscleGroup Pressed');
  //   if (_selectedSecondMuscleGroup.length > 0) {
  //     setState(() {
  //       _pageIndex = 3;
  //     });
  //   } else {
  //     showAlertDialog(
  //       context,
  //       title: 'Secondary Muscle Group',
  //       content: 'Select at least 1 secondary muscle group',
  //       defaultActionText: 'OK',
  //     );
  //   }
  // }

  void saveEquipmentRequired() {
    debugPrint('saveEquipmentRequired Pressed');
    if (_selectedEquipmentRequired.length > 0) {
      setState(() {
        _pageIndex = 3;
      });
    } else {
      showAlertDialog(
        context,
        title: 'Select Equipment Required',
        content: 'Select at least 1 Equipment for the routine',
        defaultActionText: 'OK',
      );
    }
  }

  void saveDifficulty() {
    debugPrint('saveDifficulty Pressed');
    if (_difficultySlider != null) {
      _submit();
    } else {
      showAlertDialog(
        context,
        title: 'No Difficulty',
        content: 'Select routine\'s difficulty!',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          (_pageIndex == 0)
              ? 'Workout Name'
              : (_pageIndex == 1)
                  ? 'Main Muscle Group'
                  : (_pageIndex == 2)
                      ? 'Equipment Required'
                      : 'More About This Workout',
          style: Subtitle2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: AppbarBlurBG(),
      ),
      body: Builder(
        builder: (BuildContext context) {
          switch (_pageIndex) {
            case 0:
              return _editTitleWidget();
            case 1:
              return _selectMainMuscleGroupWidget(context);
            // case 2:
            //   return _selectSecondMuscleGroup();
            case 2:
              return _selectEquipmentRequired();
            case 3:
              return _selectDifficultyAndMore(context);
            default:
              return null;
          }
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _editTitleWidget() {
    return Center(
      child: Container(
        height: 104,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          maxLength: 30,
          maxLines: 1,
          style: Headline5,
          autofocus: true,
          textAlign: TextAlign.center,
          controller: _textController1,
          decoration: const InputDecoration(
            counterStyle: Caption1,
            hintStyle: SearchBarHintStyle,
            hintText: 'Give workout a name',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: PrimaryColor),
            ),
          ),
          onChanged: (value) => setState(() {
            _workoutTitle = value;
          }),
          onSaved: (value) => setState(() {
            _workoutTitle = value;
          }),
          onFieldSubmitted: (value) => setState(() {
            _workoutTitle = value;
            saveTitle();
          }),
        ),
      ),
    );
  }

  Widget _selectMainMuscleGroupWidget(context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
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
    );
  }

  // Widget _selectSecondMuscleGroup() {
  //   return SingleChildScrollView(
  //     physics: AlwaysScrollableScrollPhysics(),
  //     child: Column(
  //       children: <Widget>[
  //         const SizedBox(height: 8),
  //         ListView(
  //           physics: const NeverScrollableScrollPhysics(),
  //           shrinkWrap: true,
  //           children: _secondMuscleGroup.keys.map((String key) {
  //             return Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Container(
  //                   color: (_secondMuscleGroup[key]) ? PrimaryColor : Grey700,
  //                   child: CheckboxListTile(
  //                     activeColor: Primary700Color,
  //                     title: Text(key, style: ButtonText),
  //                     controlAffinity: ListTileControlAffinity.trailing,
  //                     value: _secondMuscleGroup[key],
  //                     onChanged: (bool value) {
  //                       setState(() {
  //                         _secondMuscleGroup[key] = value;
  //                       });
  //                       if (_secondMuscleGroup[key]) {
  //                         _selectedSecondMuscleGroup.add(key);
  //                       } else {
  //                         _selectedSecondMuscleGroup.remove(key);
  //                       }
  //                       print(_selectedSecondMuscleGroup);
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _selectEquipmentRequired() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _equipmentRequired.keys.map((String key) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: (_equipmentRequired[key]) ? PrimaryColor : Grey700,
                    child: CheckboxListTile(
                      activeColor: Primary700Color,
                      title: Text(key, style: ButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _equipmentRequired[key],
                      onChanged: (bool value) {
                        setState(() {
                          _equipmentRequired[key] = value;
                        });
                        if (_equipmentRequired[key]) {
                          _selectedEquipmentRequired.add(key);
                        } else {
                          _selectedEquipmentRequired.remove(key);
                        }
                        print(_selectedEquipmentRequired);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _selectDifficultyAndMore(context) {
    final size = MediaQuery.of(context).size;
    final f = NumberFormat('#,###');
    final formattedSecondsPerRep = f.format(_secondsPerRepSlider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight),

                // Description
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text('Description', style: BodyText1w800),
                ),
                Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _textController2,
                      style: BodyText2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Add description here!',
                        hintStyle: BodyText2LightGrey,
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: (value) => _description = value,
                      onChanged: (value) => _description = value,
                      onSaved: (value) => _description = value,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Difficulty
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Workout Difficulty: $_difficultySliderLabel',
                    style: BodyText1w800,
                  ),
                ),
                Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slider(
                    activeColor: PrimaryColor,
                    inactiveColor: PrimaryColor.withOpacity(0.2),
                    value: _difficultySlider,
                    onChanged: (newRating) {
                      setState(() {
                        _difficultySlider = newRating;
                        _difficultySliderLabel =
                            Difficulty.values[_difficultySlider.toInt()].label;
                      });
                    },
                    label: '$_difficultySliderLabel',
                    min: 0,
                    max: 4,
                    divisions: 4,
                  ),
                ),
                const SizedBox(height: 36),

                // Seconds per Rep
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Seconds per Rep: $formattedSecondsPerRep seconds',
                    style: BodyText1w800,
                  ),
                ),
                Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Slider(
                    activeColor: PrimaryColor,
                    inactiveColor: PrimaryColor.withOpacity(0.2),
                    value: _secondsPerRepSlider,
                    onChanged: (newRating) {
                      setState(() {
                        _secondsPerRepSlider = newRating;
                        _secondsPerRepSliderLabel =
                            '$formattedSecondsPerRep seconds';
                      });
                    },
                    label: _secondsPerRepSliderLabel,
                    min: 1,
                    max: 10,
                    // divisions: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'This will help us calculate duration for a routine',
                    style: Caption1Grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Row(
      children: [
        const SizedBox(width: 32),
        if (_pageIndex > 0)
          FloatingActionButton.extended(
            heroTag: null,
            backgroundColor: Colors.grey[700],
            label: const Text('BACK', style: ButtonText),
            onPressed: () => setState(() {
              _pageIndex--;
            }),
          ),
        Spacer(),
        if (_pageIndex == 3)
          FloatingActionButton.extended(
            icon: const Icon(Icons.done, color: Colors.white),
            backgroundColor: PrimaryColor,
            label: const Text('Finish!', style: ButtonText),
            onPressed: saveDifficulty,
          ),
        if (_pageIndex < 3)
          FloatingActionButton(
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            backgroundColor: PrimaryColor,
            onPressed: (_pageIndex == 0)
                ? saveTitle
                : (_pageIndex == 1)
                    ? saveMainMuscleGroup
                    : (_pageIndex == 2)
                        ? saveEquipmentRequired
                        : saveDifficulty,
          ),
      ],
    );
  }
}
