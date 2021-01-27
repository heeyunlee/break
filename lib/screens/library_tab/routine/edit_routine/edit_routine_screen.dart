import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/screens/library_tab/routine/edit_routine/edit_second_muscle_group_screen.dart';
import 'package:workout_player/services/auth.dart';

import '../../../../common_widgets/appbar_blur_bg.dart';
import '../../../../common_widgets/max_width_raised_button.dart';
import '../../../../common_widgets/show_alert_dialog.dart';
import '../../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../../constants.dart';
import '../../../../models/routine.dart';
import '../../../../services/database.dart';
import 'edit_equipment_required_screen.dart';
import 'edit_main_muscle_group_screen.dart';

Logger logger = Logger();

class EditRoutineScreen extends StatefulWidget {
  const EditRoutineScreen({
    Key key,
    @required this.database,
    this.routine,
    this.user,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final User user;

  static Future<void> show({BuildContext context, Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditRoutineScreen(
          database: database,
          routine: routine,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditRoutineScreenState createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode1;
  FocusNode focusNode2;
  FocusNode focusNode3;
  FocusNode focusNode4;
  FocusNode focusNode5;
  FocusNode focusNode6;
  FocusNode focusNode7;
  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();
  var _textController3 = TextEditingController();
  var _textController4 = TextEditingController();
  var _textController5 = TextEditingController();
  var _textController6 = TextEditingController();
  var _textController7 = TextEditingController();

  String _routineTitle;
  String _mainMuscleGroup;
  String _secondMuscleGroup;
  String _description;
  String _imageUrl;
  int _totalWeights;
  int _averageTotalCalories;
  int _duration;
  String _equipmentRequired;

  // For SliverApp to Work
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
    focusNode5 = FocusNode();
    focusNode6 = FocusNode();
    focusNode7 = FocusNode();
    if (widget.routine != null) {
      _routineTitle = widget.routine.routineTitle;
      _textController2 = TextEditingController(text: _routineTitle);

      // _mainMuscleGroup = widget.routine.mainMuscleGroup;
      // _textController3 = TextEditingController(text: _mainMuscleGroup);

      // _secondMuscleGroup = widget.routine.secondMuscleGroup;
      // _textController4 = TextEditingController(text: _secondMuscleGroup);

      _description = widget.routine.description;
      _textController5 = TextEditingController(text: _description);

      _imageUrl = widget.routine.imageUrl;
      _textController6 = TextEditingController(text: _imageUrl);

      _totalWeights = widget.routine.totalWeights;
      _averageTotalCalories = widget.routine.averageTotalCalories;
      _duration = widget.routine.duration;
      // _equipmentRequired = widget.routine.equipmentRequired;
      // _textController7 = TextEditingController(text: _equipmentRequired);
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    focusNode7.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
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

  // Delete Routine Method
  Future<void> _delete(BuildContext context, Routine routine) async {
    try {
      await widget.database.deleteRoutine(routine);
      Navigator.of(context).popUntil((route) => route.isFirst);
      showFlushBar(
        context: context,
        message: 'Routine Deleted',
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

  // Submit data to Firestore
  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final routines = await widget.database.routinesStream().first;
        final allNames =
            routines.map((routine) => routine.routineTitle).toList();
        if (widget.routine != null) {
          allNames.remove(widget.routine.routineTitle);
        }
        if (allNames.contains(_routineTitle)) {
          showAlertDialog(
            context,
            title: '같은 이름의 루틴이 존재해요',
            content: 'Please choose a different workout name',
            defaultActionText: 'OK',
          );
        } else {
          final routineId =
              widget.routine?.routineId ?? documentIdFromCurrentDate();
          final userId = widget.user.uid;
          final userName = widget.user.displayName;
          final date = Timestamp.now();
          final timestamp = Timestamp.now();
          final routine = {
            'routineId': routineId,
            'routineOwnerId': userId,
            'routineOwnerUserName': userName,
            'routineTitle': _routineTitle,
            'lastEditedDate': timestamp,
            'routineCreatedDate': date,
            // mainMuscleGroup: widget.routine.mainMuscleGroup,
            // secondMuscleGroup: widget.routine.secondMuscleGroup,
            // mainMuscleGroup: _mainMuscleGroup,
            // secondMuscleGroup: _secondMuscleGroup,
            'description': _description,
            'imageUrl': _imageUrl,
            'totalWeights': _totalWeights,
            'averageTotalCalories': _averageTotalCalories,
            'duration': _duration,
            // equipmentRequired: widget.routine.equipmentRequired,
            // equipmentRequired: _equipmentRequired,
          };
          await widget.database.updateRoutine(widget.routine, routine).then(
                (value) => Navigator.of(context).pop(),
              );
          // Navigator.of(context).pop();
          showFlushBar(
            context: context,
            message: (widget.routine != null) ? '루틴 수정 완료!' : '새로운루틴을 생성했습니다',
          );
        }
      } on FirebaseException catch (e) {
        ShowExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Routine>(
        stream:
            widget.database.routineStream(routineId: widget.routine.routineId),
        builder: (context, snapshot) {
          final routine = snapshot.data;

          return Scaffold(
            backgroundColor: BackgroundColor,
            appBar: AppBar(
              // elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                routine == null ? '루틴 생성하기' : '루틴 수정하기',
                style: Subtitle1,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(routine == null ? 'CREATE' : 'SAVE',
                      style: ButtonText),
                  onPressed: _submit,
                ),
              ],
              flexibleSpace: routine == null ? null : AppbarBlurBG(),
            ),
            body: _buildContents(routine),
          );
        });
  }

  Widget _buildContents(Routine routine) {
    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: KeyboardActions(
        config: _buildConfig(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildForm(routine),
              SizedBox(height: 32),
              if (widget.routine != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaxWidthRaisedButton(
                    color: Colors.red,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    buttonText: '삭제',
                    onPressed: () async {
                      await _showModalBottomSheet(context);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Routine routine) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitleForm(),
          _buildDescriptionForm(),
          _buildMainMuscleGroupForm(routine),
          _buildSecondMuscleGroupForm(routine),
          _buildEquipmentRequiredForm(routine),
        ],
      ),
    );
  }

  Widget _buildTitleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Routine Title',
            style: BodyText1.copyWith(color: PrimaryGrey),
          ),
        ),

        /// Routine Title
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController2,
              style: BodyText2,
              focusNode: focusNode1,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              // onEditingComplete: () => focusNode3.requestFocus(),
              validator: (value) => value.isNotEmpty ? null : '루틴에 이름을 지어 주세요!',
              onFieldSubmitted: (value) => _routineTitle = value,
              onChanged: (value) => _routineTitle = value,
              onSaved: (value) => _routineTitle = value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Description',
            style: BodyText1.copyWith(color: PrimaryGrey),
          ),
        ),

        /// Description
        Card(
          color: CardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _textController5,
              style: BodyText2,
              focusNode: focusNode2,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'ex) dasda asdqpiw oadn alskdnoq noaisdn',
                hintStyle: BodyText2LightGrey,
                border: InputBorder.none,
              ),
              // onEditingComplete: () => focusNode6.requestFocus(),
              onFieldSubmitted: (value) => _description = value,
              onChanged: (value) => _description = value,
              onSaved: (value) => _description = value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainMuscleGroupForm(Routine routine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'More',
            style: BodyText1.copyWith(color: PrimaryGrey),
          ),
        ),

        /// Main Muscle Group
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              title: Text('Main Muscle Group', style: ButtonText),
              subtitle: Text(
                (routine.mainMuscleGroup.length == 1)
                    ? '${routine.mainMuscleGroup[0]}'
                    : (routine.mainMuscleGroup.length == 2)
                        ? '${routine.mainMuscleGroup[0]}, ${routine.mainMuscleGroup[1]}'
                        : '${routine.mainMuscleGroup[0]}, ${routine.mainMuscleGroup[1]}, 등등',
                style: BodyText2.copyWith(color: Colors.grey),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, color: PrimaryGrey),
              tileColor: CardColor,
              onTap: () => EditMainMuscleGroupScreen.show(
                context,
                routine: routine,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondMuscleGroupForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: Text('Second Muscle Group', style: ButtonText),
          subtitle: Text(
            (routine.secondMuscleGroup.length == 1)
                ? '${routine.secondMuscleGroup[0]}'
                : (routine.secondMuscleGroup.length == 2)
                    ? '${routine.secondMuscleGroup[0]}, ${routine.secondMuscleGroup[1]}'
                    : '${routine.secondMuscleGroup[0]}, ${routine.secondMuscleGroup[1]}, 등등',
            style: BodyText2.copyWith(color: Colors.grey),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: PrimaryGrey),
          tileColor: CardColor,
          onTap: () => EditSecondMuscleGroupScreen.show(
            context,
            routine: routine,
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentRequiredForm(Routine routine) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          title: Text('Second Muscle Group', style: ButtonText),
          subtitle: Text(
            (routine.equipmentRequired.length == 1)
                ? '${routine.equipmentRequired[0]}'
                : (routine.equipmentRequired.length == 2)
                    ? '${routine.equipmentRequired[0]}, ${routine.equipmentRequired[1]}'
                    : '${routine.equipmentRequired[0]}, ${routine.equipmentRequired[1]}, 등등',
            style: BodyText2.copyWith(color: Colors.grey),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: PrimaryGrey),
          tileColor: CardColor,
          onTap: () => EditEquipmentRequiredScreen.show(
            context,
            routine: routine,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      /// Routine Title
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController2,
        style: BodyText2,
        focusNode: focusNode2,
        decoration: InputDecoration(
          labelText: '루틴 이름',
          labelStyle: Subtitle2.copyWith(color: Colors.grey),
          hintText: 'ex) 집에서 하는 가슴 운동!',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController2.clear();
            },
          ),
        ),
        onEditingComplete: () => focusNode3.requestFocus(),
        validator: (value) => value.isNotEmpty ? null : '루틴에 이름을 지어 주세요!',
        onFieldSubmitted: (value) => _routineTitle = value,
        onChanged: (value) => _routineTitle = value,
        onSaved: (value) => _routineTitle = value,
      ),

      // /// Main Muscle Group
      // DropdownButtonFormField(
      //   focusNode: focusNode2,
      //   icon: Icon(
      //     Icons.arrow_drop_down_rounded,
      //     color: Colors.white,
      //   ),
      //   dropdownColor: Grey700,
      //   value: _mainMuscleGroup,
      //   decoration: InputDecoration(
      //     labelText: '주요 자극 부위',
      //     labelStyle: Subtitle2Grey,
      //   ),
      //   onChanged: (String newValue) {
      //     setState(() {
      //       _mainMuscleGroup = newValue;
      //     });
      //   },
      //   items: <String>[
      //     '가슴',
      //     '등',
      //     '팔',
      //     '복근',
      //     '하체',
      //     '어깨',
      //   ].map<DropdownMenuItem<String>>(
      //     (String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(
      //           value.toString(),
      //           style: BodyText2,
      //         ),
      //       );
      //     },
      //   ).toList(),
      //   onTap: () => focusNode3.requestFocus(),
      //   onSaved: (value) => _mainMuscleGroup = value,
      // ),

      /// Main Muscle Group
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController3,
        style: BodyText2,
        focusNode: focusNode3,
        decoration: InputDecoration(
          labelText: '메인 자극 부위',
          labelStyle: Subtitle2.copyWith(color: Colors.grey),
          hintText: 'ex) 어깨, 등, 가슴, 하체',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController3.clear();
            },
          ),
        ),
        onEditingComplete: () => focusNode4.requestFocus(),
        onFieldSubmitted: (value) => _mainMuscleGroup = value,
        onChanged: (value) => _mainMuscleGroup = value,
        onSaved: (value) => _mainMuscleGroup = value,
      ),

      /// Secondary Muscle Group
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController4,
        style: BodyText2,
        focusNode: focusNode4,
        decoration: InputDecoration(
          labelText: '보조 자극 부위',
          labelStyle: Subtitle2.copyWith(color: Colors.grey),
          hintText: 'ex) 어깨, 삼두, 복근',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController4.clear();
            },
          ),
        ),
        onEditingComplete: () => focusNode5.requestFocus(),
        onFieldSubmitted: (value) => _secondMuscleGroup = value,
        onChanged: (value) => _secondMuscleGroup = value,
        onSaved: (value) => _secondMuscleGroup = value,
      ),

      /// Description
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController5,
        style: BodyText2,
        focusNode: focusNode5,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Routine Description',
          labelStyle: Subtitle2.copyWith(color: Colors.grey),
          hintText: 'ex) dasda asdqpiw oadn alskdnoq noaisdn',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController5.clear();
            },
          ),
        ),
        onEditingComplete: () => focusNode6.requestFocus(),
        onFieldSubmitted: (value) => _description = value,
        onChanged: (value) => _description = value,
        onSaved: (value) => _description = value,
      ),

      /// Image Url
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController6,
        style: BodyText2,
        focusNode: focusNode6,
        decoration: InputDecoration(
          labelText: '사진 URL',
          labelStyle: Subtitle2.copyWith(color: Colors.grey),
          hintText: 'https://www.~',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController6.clear();
            },
          ),
        ),
        onEditingComplete: () => focusNode7.requestFocus(),
        onFieldSubmitted: (value) => _imageUrl = value,
        onChanged: (value) => _imageUrl = value,
        onSaved: (value) => _imageUrl = value,
      ),

      /// Equipment Required
      TextFormField(
        textInputAction: TextInputAction.done,
        controller: _textController7,
        style: BodyText2,
        focusNode: focusNode7,
        decoration: InputDecoration(
          labelText: 'Equipment Required',
          labelStyle: Subtitle2.copyWith(color: Colors.grey),
          hintText: '바벨, 케틀벨, 등등',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController7.clear();
            },
          ),
        ),
        onFieldSubmitted: (value) => _equipmentRequired = value,
        onChanged: (value) => _equipmentRequired = value,
        onSaved: (value) => _equipmentRequired = value,
      ),
    ];
  }

  Future<bool> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context: context,
      message: Text(
        '정말로 루틴을 삭제하시겠습니까? You can\'t undo this process',
        textAlign: TextAlign.center,
      ),
      firstActionText: '루틴 삭제',
      isFirstActionDefault: false,
      firstActionOnPressed: () => {_delete(context, widget.routine)},
      cancelText: '취소',
      isCancelDefault: true,
    );
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardSeparatorColor: Grey700,
      keyboardBarColor: Color(0xff303030),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode1,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode2,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode3,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode4,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode5,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode6,
          displayDoneButton: false,
        ),
        KeyboardActionsItem(
          focusNode: focusNode7,
          displayDoneButton: false,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('완료', style: ButtonText),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}

// class EditPlaylistScreenRoute extends CupertinoPageRoute {
//   EditPlaylistScreenRoute()
//       : super(builder: (BuildContext context) => new EditPlaylistScreen());
//
//   // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return new SlideTransition(
//       child: new EditPlaylistScreen(),
//     );
//   }
// }
