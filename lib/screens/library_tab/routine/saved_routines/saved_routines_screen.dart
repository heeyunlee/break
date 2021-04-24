import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

class SavedRoutinesScreen extends StatelessWidget {
  final Database database;
  final User user;

  const SavedRoutinesScreen({
    Key key,
    this.database,
    this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {User user}) async {
    final database = Provider.of<Database>(context, listen: false);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SavedRoutinesScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: Text(S.current.proteinEntriesTitle, style: Subtitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: AppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
