import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/user_feedback.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

Logger logger = Logger();

class UserFeedbackScreen extends StatefulWidget {
  final User user;
  final Database database;

  const UserFeedbackScreen({Key key, this.user, this.database})
      : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userStream(userId: auth.currentUser.uid).first;

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => UserFeedbackScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  @override
  _UserFeedbackScreenState createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  String _userFeedback;
  var _textController1 = TextEditingController();

  @override
  void initState() {
    _userFeedback = null;
    _textController1 = TextEditingController(text: _userFeedback);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      final userFeedbackId = documentIdFromCurrentDate();
      final createdDate = Timestamp.now();

      final userFeedback = UserFeedback(
        userFeedbackId: userFeedbackId,
        userId: widget.user.userId,
        username: widget.user.userName,
        createdDate: createdDate,
        feedback: _userFeedback,
        userEmail: widget.user.userEmail,
        isResolved: false,
      );
      await widget.database.setUserFeedback(userFeedback);
      Navigator.of(context).pop();
      ShowFlushBar(context: context, message: 'Thanks for the feedback!');
    } on FirebaseException catch (e) {
      logger.d(e);
      showExceptionAlertDialog(
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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Your Feedback Matters!', style: Subtitle2),
        actions: [
          FlatButton(
            child: const Text('SUBMIT', style: ButtonText),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: size.height,
        child: TextField(
          controller: _textController1,
          maxLines: 20,
          autofocus: true,
          style: BodyText1Height,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText:
                'Please tell us what we could do to improve this app and your workout experience.',
            hintStyle: BodyText1Grey,
          ),
          onChanged: (value) {
            setState(() {
              _userFeedback = value;
            });
          },
          onSubmitted: (value) {
            setState(() {
              _userFeedback = value;
            });
          },
        ),
      ),
    );
  }
}
