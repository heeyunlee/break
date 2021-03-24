import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';

Logger logger = Logger();

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({
    Key key,
    @required this.database,
    @required this.user,
    @required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show({BuildContext context, User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => PersonalInformationScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  String _userName;

  var _textController1 = TextEditingController();
  FocusNode focusNode1;

  @override
  void initState() {
    _userName = widget.user.userName;
    _textController1 = TextEditingController(text: _userName);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _updateUserName() async {
    if (_userName.isNotEmpty) {
      try {
        final user = {
          'userName': _userName,
        };
        await widget.database.updateUser(widget.auth.currentUser.uid, user);
        debugPrint('Updated Username');
      } on FirebaseException catch (e) {
        logger.d(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      return showAlertDialog(
        context,
        title: S.current.usernameEmptyTitle,
        content: S.current.usernameEmptyContent,
        defaultActionText: S.current.ok,
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
        title: Text(S.current.editUserNameTitle, style: Subtitle1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            style: Headline5,
            autofocus: true,
            textAlign: TextAlign.center,
            controller: _textController1,
            maxLength: 25,
            decoration: InputDecoration(
              hintStyle: SearchBarHintStyle,
              hintText: S.current.usernameHintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              counterStyle: Caption1Grey,
            ),
            onChanged: (value) => setState(() {
              _userName = value;
            }),
            onSaved: (value) => setState(() {
              _userName = value;
            }),
            onFieldSubmitted: (value) {
              setState(() {
                _userName = value;
              });
              _updateUserName();
            },
          ),
        ),
        Text(S.current.yourUsername, style: BodyText1Grey),
      ],
    );
  }
}
