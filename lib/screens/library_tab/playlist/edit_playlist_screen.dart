import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';

import '../../../common_widgets/appbar_blur_bg.dart';
import '../../../common_widgets/max_width_raised_button.dart';
import '../../../common_widgets/show_alert_dialog.dart';
import '../../../common_widgets/show_exception_alert_dialog.dart';
import '../../../constants.dart';
import '../../../models/routine.dart';
import '../../../services/database.dart';

Logger logger = Logger();

class EditPlaylistScreen extends StatefulWidget {
  const EditPlaylistScreen({Key key, @required this.database, this.routine})
      : super(key: key);

  final Database database;
  final Routine routine;

  static Future<void> show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditPlaylistScreen(
          database: database,
          routine: routine,
        ),
      ),
    );
  }

  @override
  _EditPlaylistScreenState createState() => _EditPlaylistScreenState();
}

class _EditPlaylistScreenState extends State<EditPlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode1;
  FocusNode focusNode2;
  FocusNode focusNode3;
  FocusNode focusNode4;
  FocusNode focusNode5;
  var _textController1 = TextEditingController();
  var _textController2 = TextEditingController();
  var _textController3 = TextEditingController();
  var _textController4 = TextEditingController();
  var _textController5 = TextEditingController();
  var _textController6 = TextEditingController();

  String _routineOwnerId;
  String _routineTitle;
  String _mainMuscleGroup;
  String _secondMuscleGroup;
  String _description;
  String _imageUrl;
  int _totalWeights;
  int _averageTotalCalories;
  int _duration;

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
    if (widget.routine != null) {
      _routineOwnerId = widget.routine.routineOwnerId;
      _textController1 = TextEditingController(text: _routineOwnerId);

      _routineTitle = widget.routine.routineTitle;
      _textController2 = TextEditingController(text: _routineTitle);

      _mainMuscleGroup = widget.routine.mainMuscleGroup;
      _textController3 = TextEditingController(text: _mainMuscleGroup);

      _secondMuscleGroup = widget.routine.secondMuscleGroup;
      _textController4 = TextEditingController(text: _secondMuscleGroup);

      _description = widget.routine.description;
      _textController5 = TextEditingController(text: _description);

      _imageUrl = widget.routine.imageUrl;
      _textController6 = TextEditingController(text: _imageUrl);

      _totalWeights = widget.routine.totalWeights;
      _averageTotalCalories = widget.routine.averageTotalCalories;
      _duration = widget.routine.duration;
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
    } on FirebaseException catch (e) {
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
        final workouts = await widget.database.workoutsStream().first;
        final allNames =
            workouts.map((workout) => workout.workoutTitle).toList();
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
          final id = widget.routine?.routineId ?? documentIdFromCurrentDate();
          final date = Timestamp.now();
          final timestamp = Timestamp.now();
          final routine = Routine(
            routineId: id,
            routineOwnerId: _routineOwnerId,
            routineTitle: _routineTitle,
            lastEditedDate: timestamp,
            routineCreatedDate: date,
            mainMuscleGroup: _mainMuscleGroup,
            secondMuscleGroup: _secondMuscleGroup,
            description: _description,
            imageUrl: _imageUrl,
            totalWeights: _totalWeights,
            averageTotalCalories: _averageTotalCalories,
            duration: _duration,
          );
          await widget.database.setRoutine(routine);
          Navigator.of(context).pop();
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
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        elevation: 0,
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
          widget.routine == null ? '루틴 생성하기' : '루틴 수정하기',
          style: Subtitle1,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(widget.routine == null ? 'CREATE' : 'SAVE',
                style: ButtonText),
            onPressed: _submit,
          ),
        ],
        flexibleSpace: widget.routine == null ? null : AppbarBlurBG(),
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: CardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
          ),
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
    );
  }

  Widget _buildForm() {
    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      /// routineOwnerId
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController1,
        style: BodyText2,
        autofocus: widget.routine == null ? true : false,
        decoration: InputDecoration(
          labelText: '루틴 지은이',
          labelStyle: Subtitle2Grey,
          hintText: 'ex) 플레이어 H',
          hintStyle: BodyText2LightGrey,
          suffixIconConstraints: BoxConstraints(maxWidth: 24, maxHeight: 24),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Colors.white,
              size: 16,
            ),
            onPressed: () {
              _textController1.clear();
            },
          ),
        ),
        onEditingComplete: () => focusNode1.requestFocus(),
        validator: (value) => value.isNotEmpty ? null : '루틴 지은이를 적어주세요!',
        onSaved: (value) => _routineOwnerId = value,
      ),

      /// Routine Title
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController2,
        style: BodyText2,
        focusNode: focusNode1,
        decoration: InputDecoration(
          labelText: '루틴 이름',
          labelStyle: Subtitle2Grey,
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
        onEditingComplete: () => focusNode2.requestFocus(),
        validator: (value) => value.isNotEmpty ? null : '루틴에 이름을 지어 주세요!',
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
        focusNode: focusNode2,
        decoration: InputDecoration(
          labelText: '메인 자극 부위',
          labelStyle: Subtitle2Grey,
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
        onEditingComplete: () => focusNode3.requestFocus(),
        onSaved: (value) => _mainMuscleGroup = value,
      ),

      /// Secondary Muscle Group
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController4,
        style: BodyText2,
        focusNode: focusNode3,
        decoration: InputDecoration(
          labelText: '보조 자극 부위',
          labelStyle: Subtitle2Grey,
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
        onEditingComplete: () => focusNode4.requestFocus(),
        onSaved: (value) => _secondMuscleGroup = value,
      ),

      /// Description
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _textController5,
        style: BodyText2,
        focusNode: focusNode4,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Routine Description',
          labelStyle: Subtitle2Grey,
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
        onEditingComplete: () => focusNode5.requestFocus(),
        onSaved: (value) => _description = value,
      ),

      /// Image Url
      TextFormField(
        textInputAction: TextInputAction.done,
        controller: _textController6,
        style: BodyText2,
        focusNode: focusNode5,
        decoration: InputDecoration(
          labelText: '사진 URL',
          labelStyle: Subtitle2Grey,
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
        onSaved: (value) => _imageUrl = value,
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
      firstActionOnPressed: () {
        _delete(context, widget.routine);
        Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => SavedPlaylistTab()),
        //   ModalRoute.withName('/'),
        // );
      },
      cancelText: '취소',
      isCancelDefault: true,
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
