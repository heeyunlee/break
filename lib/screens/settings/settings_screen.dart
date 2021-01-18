import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/auth.dart';

import '../../common_widgets/show_alert_dialog.dart';
import '../../constants.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      cancelAcitionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      return _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.black26.withOpacity(0.1)),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('설정', style: Subtitle1),
      ),
      backgroundColor: BackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 64),
            Center(
              child: RaisedButton(
                child: Text('로그아웃 하기'),
                onPressed: () => _confirmSignOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
