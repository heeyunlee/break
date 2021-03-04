import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings/unit_of_mass_screen.dart';
import 'package:workout_player/screens/settings/user_feedback_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../common_widgets/show_alert_dialog.dart';
import '../../constants.dart';
import 'personal_information_screen.dart';

Logger logger = Logger();

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
    this.database,
    this.auth,
    this.user,
  }) : super(key: key);

  final Database database;
  final AuthBase auth;
  final User user;

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userStream(userId: auth.currentUser.uid).first;
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => SettingsScreen(
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );
  }

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _signOut(BuildContext context) async {
    try {
      // FirebaseCrashlytics.instance.crash();
      await widget.auth.signOut();
      Navigator.of(context).pop();
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
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings', style: Subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return StreamBuilder<User>(
      initialData: widget.user,
      stream: widget.database.userStream(userId: widget.auth.currentUser.uid),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight + 16),
                // const Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                //   child: const Text('Account Setting', style: BodyText2Grey),
                // ),
                ListTile(
                  // tileColor: CardColor,
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Personal Information', style: BodyText2),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                  onTap: () => PersonalInformationScreen.show(
                    context: context,
                    user: widget.user,
                  ),
                ),
                ListTile(
                  // tileColor: CardColor,
                  leading: const Icon(
                    Icons.straighten_rounded,
                    color: Colors.white,
                  ),
                  title: const Text('Unit of Mass', style: BodyText2),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        UnitOfMass.values[user.unitOfMass].label,
                        style: BodyText2Grey,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () => UnitOfMassScreen.show(
                    context: context,
                    user: user,
                  ),
                ),
                // const SizedBox(height: 24),
                // const Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                //   child: const Text('About', style: BodyText2Grey),
                // ),
                ListTile(
                  // tileColor: CardColor,
                  leading: const Icon(Icons.feedback, color: Colors.white),
                  title: const Text('Feedback & Feature Requests',
                      style: BodyText2),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                  onTap: () => UserFeedbackScreen.show(context),
                ),
                ListTile(
                  // tileColor: CardColor,
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                  ),
                  title: const Text('About', style: BodyText2),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                  onTap: () {},
                ),
                Spacer(),
                // SizedBox(height: size.height / 2),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaxWidthRaisedButton(
                    buttonText: 'Logout',
                    color: Grey700,
                    onPressed: () => _confirmSignOut(context),
                  ),
                ),
                SizedBox(height: 38),
              ],
            ),
          ),
        );
      },
    );
  }
}
