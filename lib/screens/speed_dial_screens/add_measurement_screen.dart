import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class AddMeasurementScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AuthBase auth;

  const AddMeasurementScreen({Key key, this.user, this.database, this.auth})
      : super(key: key);

  static Future<void> show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userDocument(auth.currentUser.uid);

    await HapticFeedback.mediumImpact();
    await pushNewScreen(
      context,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
      withNavBar: false,
      screen: AddMeasurementScreen(
        database: database,
        user: user,
        auth: auth,
      ),
    );
  }

  @override
  _AddMeasurementScreenState createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();

  Timestamp _loggedTime;
  String _loggedTimeInString;
  DateTime _loggedDate;

  num _bodyWeight;
  TextEditingController _textController1;
  FocusNode _focusNode1;

  num _bodyFat;
  TextEditingController _textController2;
  FocusNode _focusNode2;

  num _skeletalMuscleMass;
  TextEditingController _textController3;
  FocusNode _focusNode3;

  num _bmi;
  TextEditingController _textController4;
  FocusNode _focusNode4;

  String _notes;
  TextEditingController _textController5 = TextEditingController();
  FocusNode _focusNode5;

  @override
  void initState() {
    super.initState();
    _loggedTime = Timestamp.now();
    _loggedTimeInString = Format.yMdjmInDateTime(_loggedTime.toDate());
    final nowInDate = _loggedTime.toDate();
    _loggedDate = DateTime.utc(nowInDate.year, nowInDate.month, nowInDate.day);

    _textController1 = TextEditingController();
    _focusNode1 = FocusNode();

    _textController2 = TextEditingController();
    _focusNode2 = FocusNode();

    _textController3 = TextEditingController();
    _focusNode3 = FocusNode();

    _textController4 = TextEditingController();
    _focusNode4 = FocusNode();

    _textController5 = TextEditingController();
    _focusNode5 = FocusNode();
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    _textController4.dispose();
    _textController5.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();

    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      debugPrint('validated');
      print('bodyweight $_bodyWeight');
      print('bodyfat $_bodyFat');
      print('muscle mass is $_skeletalMuscleMass');
      print('bmi is $_bmi');
      print('notes is $_notes');
      print(_loggedTime);
      print(_loggedTimeInString);
      print(_loggedDate);
      try {} on FirebaseException catch (e) {
        logger.d(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    }
  }

  void _showDatePicker(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: CardColorLight,
          height: size.height / 3,
          child: CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              initialDateTime: _loggedTime.toDate(),
              onDateTimeChanged: (value) => setState(() {
                _loggedTime = Timestamp.fromDate(value);
                _loggedTimeInString = Format.yMdjmInDateTime(
                  _loggedTime.toDate(),
                );
                _loggedDate = DateTime.utc(value.year, value.month, value.day);
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
        backgroundColor: AppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        title: Text(S.current.addWorkoutLog, style: Subtitle2),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: Container(
        width: size.width - 32,
        padding: EdgeInsets.only(
          bottom: (_focusNode1.hasFocus ||
                  _focusNode2.hasFocus ||
                  _focusNode3.hasFocus ||
                  _focusNode4.hasFocus ||
                  _focusNode5.hasFocus)
              ? 48
              : 0,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _submit(),
          backgroundColor: PrimaryColor,
          heroTag: 'addMeasurementSubmitButton',
          label: Text(S.current.submit),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final unitOfMass = Format.unitOfMass(widget.user.unitOfMass);

    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Logged Time
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () => _showDatePicker(context),
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _loggedTimeInString,
                                style: BodyText1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: -6,
                        child: Container(
                          color: BackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(S.current.time, style: Caption1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bodyweight
                  TextFormField(
                    focusNode: _focusNode1,
                    controller: _textController1,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: S.current.bodyweightMeasurement,
                      labelStyle: BodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: SecondaryColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixText: unitOfMass,
                      suffixStyle: BodyText1,
                    ),
                    style: BodyText1,
                    validator: (value) {
                      print(value.runtimeType);
                      if (value.isEmpty) {
                        return S.current.weightsHintText;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      _bodyWeight = num.parse(value);
                      _formKey.currentState.validate();
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _bodyWeight = num.parse(value);
                      _formKey.currentState.validate();
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Body Fat
                  TextFormField(
                    focusNode: _focusNode2,
                    controller: _textController2,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: S.current.bodyFat,
                      labelStyle: BodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: SecondaryColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixText: '%',
                      suffixStyle: BodyText1,
                    ),
                    style: BodyText1,
                    onChanged: (value) => setState(() {
                      _bodyFat = num.parse(value);
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _bodyFat = num.parse(value);
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Skeletal Muscle Mass
                  TextFormField(
                    focusNode: _focusNode3,
                    controller: _textController3,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: S.current.skeletalMuscleMass,
                      labelStyle: BodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: SecondaryColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixText: unitOfMass,
                      suffixStyle: BodyText1,
                    ),
                    style: BodyText1,
                    onChanged: (value) => setState(() {
                      _skeletalMuscleMass = num.parse(value);
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _skeletalMuscleMass = num.parse(value);
                    }),
                  ),
                  const SizedBox(height: 24),

                  // BMI
                  TextFormField(
                    focusNode: _focusNode4,
                    controller: _textController4,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'BMI',
                      labelStyle: BodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: SecondaryColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // suffixText: '$unitOfMass/m^2',
                      suffixStyle: BodyText1,
                    ),
                    style: BodyText1,
                    onChanged: (value) => setState(() {
                      _bmi = num.parse(value);
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _bmi = num.parse(value);
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  TextFormField(
                    focusNode: _focusNode5,
                    controller: _textController5,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: S.current.notes,
                      labelStyle: BodyText1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: SecondaryColor),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: BodyText1,
                    onChanged: (value) => setState(() {
                      _notes = value;
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      _notes = value;
                    }),
                  ),

                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
      keyboardBarColor: const Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode1,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode2,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode3,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode4,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _focusNode5,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(S.current.done, style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
