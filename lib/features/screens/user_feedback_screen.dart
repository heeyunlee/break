import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class UserFeedbackScreen extends ConsumerStatefulWidget {
  final User user;

  const UserFeedbackScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => UserFeedbackScreen(user: user),
    );
  }

  @override
  ConsumerState<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends ConsumerState<UserFeedbackScreen> {
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
      final id = 'UF${const Uuid().v1()}';
      final createdDate = Timestamp.now();

      final userFeedback = UserFeedback(
        userFeedbackId: id,
        userId: widget.user.userId,
        username: widget.user.userName,
        createdDate: createdDate,
        feedback: _userFeedback,
        userEmail: widget.user.userEmail,
        isResolved: false,
      );

      final database = ref.watch(databaseProvider);
      await database.setUserFeedback(userFeedback);

      if (!mounted) return;

      Navigator.of(context).pop();

      // getSnackbarWidget(
      //   S.current.submitUserFeedbackSnackbarTitle,
      //   S.current.submitUserFeedbackSnackbarMessage,
      // );
    } on FirebaseException catch (e) {
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
        leading: const AppBarCloseButton(),
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
          style: TextStyles.body1Heighted,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.current.feedbackHintText,
            hintStyle: TextStyles.body1Grey,
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
