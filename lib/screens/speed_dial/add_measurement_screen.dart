import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/measurement.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class AddMeasurementScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AuthBase auth;

  const AddMeasurementScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.auth,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    // final user = (await database.getUserDocument(auth.currentUser!.uid))!;
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddMeasurementScreen(
          user: user,
          database: database,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _AddMeasurementScreenState createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();

  late Timestamp _loggedTime;
  late String _loggedTimeInString;
  late DateTime _loggedDate;

  num get _bodyWeight => num.parse(_textController1.text);
  late TextEditingController _textController1;
  late FocusNode _focusNode1;

  num? get _bodyFat => num.tryParse(_textController2.text);
  late TextEditingController _textController2;
  late FocusNode _focusNode2;

  num? get _skeletalMuscleMass => num.tryParse(_textController3.text);
  late TextEditingController _textController3;
  late FocusNode _focusNode3;

  num? get _bmi => num.tryParse(_textController4.text);
  late TextEditingController _textController4;
  late FocusNode _focusNode4;

  String? get _notes => _textController5.text;
  late TextEditingController _textController5;
  late FocusNode _focusNode5;

  @override
  void initState() {
    super.initState();
    _loggedTime = Timestamp.now();
    _loggedTimeInString = Formatter.yMdjmInDateTime(_loggedTime.toDate());
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
    _focusNode1.dispose();

    _textController2.dispose();
    _focusNode2.dispose();

    _textController3.dispose();
    _focusNode3.dispose();

    _textController4.dispose();
    _focusNode4.dispose();

    _textController5.dispose();
    _focusNode5.dispose();

    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        // final id = documentIdFromCurrentDate();
        final id = 'MS${Uuid().v1()}';

        final measurement = Measurement(
          measurementId: id,
          userId: widget.user.userId,
          username: widget.user.userName,
          loggedTime: _loggedTime,
          loggedDate: _loggedDate,
          bodyWeight: _bodyWeight,
          bodyFat: _bodyFat,
          skeletalMuscleMass: _skeletalMuscleMass,
          bmi: _bmi,
          notes: _notes,
        );

        await widget.database.setMeasurement(
          // uid: widget.user.userId,
          measurement: measurement,
        );

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.addMeasurementSnackbarTitle,
          S.current.addMeasurementSnackbar,
        );
      } on FirebaseException catch (e) {
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
          color: kCardColorLight,
          height: size.height / 3,
          child: CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              initialDateTime: _loggedTime.toDate(),
              onDateTimeChanged: (value) => setState(() {
                _loggedTime = Timestamp.fromDate(value);
                _loggedTimeInString = Formatter.yMdjmInDateTime(
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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        title: Text(S.current.addMeasurement, style: TextStyles.subtitle2),
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
          backgroundColor: kPrimaryColor,
          heroTag: 'addMeasurementSubmitButton',
          label: Text(S.current.submit),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final unitOfMass = Formatter.unitOfMass(widget.user.unitOfMass);

    return Theme(
      data: ThemeData(
        primaryColor: kPrimaryColor,
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
                                style: TextStyles.body1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: -6,
                        child: Container(
                          color: kBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              S.current.time,
                              style: TextStyles.caption1,
                            ),
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
                      labelStyle: TextStyles.body1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
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
                      suffixStyle: TextStyles.body1,
                    ),
                    style: TextStyles.body1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.current.weightsHintText;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      // _bodyWeight = num.parse(value);
                      _formKey.currentState!.validate();
                    }),
                    onFieldSubmitted: (value) => setState(() {
                      // _bodyWeight = num.parse(value);
                      _formKey.currentState!.validate();
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
                      labelStyle: TextStyles.body1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
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
                      suffixStyle: TextStyles.body1,
                    ),
                    style: TextStyles.body1,
                    onChanged: (value) => setState(() {}),
                    onFieldSubmitted: (value) => setState(() {}),
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
                      labelStyle: TextStyles.body1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
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
                      suffixStyle: TextStyles.body1,
                    ),
                    style: TextStyles.body1,
                    onChanged: (value) => setState(() {}),
                    onFieldSubmitted: (value) => setState(() {}),
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
                      labelStyle: TextStyles.body1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
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
                      suffixStyle: TextStyles.body1,
                    ),
                    style: TextStyles.body1,
                    onChanged: (value) => setState(() {}),
                    onFieldSubmitted: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  TextFormField(
                    focusNode: _focusNode5,
                    controller: _textController5,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: S.current.notes,
                      labelStyle: TextStyles.body1,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
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
                    style: TextStyles.body1,
                    onChanged: (value) => setState(() {}),
                    onFieldSubmitted: (value) => setState(() {}),
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
      keyboardSeparatorColor: kGrey700,
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
                  child: Text(S.current.done, style: TextStyles.button1),
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
                  child: Text(S.current.done, style: TextStyles.button1),
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
                  child: Text(S.current.done, style: TextStyles.button1),
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
                  child: Text(S.current.done, style: TextStyles.button1),
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
                  child: Text(S.current.done, style: TextStyles.button1),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
