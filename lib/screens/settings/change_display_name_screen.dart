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

class ChangeDisplayNameScreen extends StatefulWidget {
  const ChangeDisplayNameScreen({
    Key key,
    @required this.database,
    @required this.user,
    @required this.auth,
  }) : super(key: key);

  final Database database;
  final User user;
  final AuthBase auth;

  static Future<void> show(BuildContext context, {User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChangeDisplayNameScreen(
          database: database,
          user: user,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _ChangeDisplayNameScreenState createState() =>
      _ChangeDisplayNameScreenState();
}

class _ChangeDisplayNameScreenState extends State<ChangeDisplayNameScreen> {
  String _displayName;

  var _textController1 = TextEditingController();
  FocusNode focusNode1;

  @override
  void initState() {
    _displayName = widget.user.displayName;
    _textController1 = TextEditingController(text: _displayName);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _updateDisplayName() async {
    if (_displayName.isNotEmpty) {
      try {
        final user = {
          'displayName': _displayName,
        };
        await widget.database.updateUser(widget.auth.currentUser.uid, user);
        debugPrint('Updated Display Name');

        // SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.updateDisplayNameSnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
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
        title: S.current.displayNameEmptyTitle,
        content: S.current.displayNameEmptyContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(S.current.editDisplayNameTitle, style: Subtitle1),
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
              hintText: S.current.displayNameHintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: PrimaryColor),
              ),
              counterStyle: Caption1Grey,
            ),
            onChanged: (value) => setState(() {
              _displayName = value;
            }),
            onSaved: (value) => setState(() {
              _displayName = value;
            }),
            onFieldSubmitted: (value) {
              setState(() {
                _displayName = value;
              });
              _updateDisplayName();
            },
          ),
        ),
        Text(S.current.yourDisplayName, style: BodyText1Grey),
      ],
    );
  }
}
