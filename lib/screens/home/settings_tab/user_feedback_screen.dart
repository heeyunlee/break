import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/user_feedback.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class UserFeedbackScreen extends StatefulWidget {
  final User user;
  final Database database;

  const UserFeedbackScreen({
    Key? key,
    required this.user,
    required this.database,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.getUserDocument(auth.currentUser!.uid);

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => UserFeedbackScreen(
          database: database,
          user: user!,
        ),
      ),
    );
  }

  @override
  _UserFeedbackScreenState createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  late String _userFeedback;
  late TextEditingController _textController1;

  @override
  void initState() {
    super.initState();
    _userFeedback = '';
    _textController1 = TextEditingController(text: _userFeedback);
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
        userFeedbackId: 'UF$userFeedbackId',
        userId: widget.user.userId,
        username: widget.user.userName,
        createdDate: createdDate,
        feedback: _userFeedback,
        userEmail: widget.user.userEmail,
        isResolved: false,
      );
      await widget.database.setUserFeedback(userFeedback);
      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.submitUserFeedbackSnackbarTitle,
        S.current.submitUserFeedbackSnackbarMessage,
      );
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Thank you for your feedback!'),
      //   duration: Duration(seconds: 2),
      //   behavior: SnackBarBehavior.floating,
      // ));
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
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.yourFeedbackMatters, style: TextStyles.subtitle2),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(S.current.submit, style: TextStyles.button1),
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
          style: kBodyText1Height,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.current.feedbackHintText,
            hintStyle: kBodyText1Grey,
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
