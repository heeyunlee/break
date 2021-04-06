import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings/unit_of_mass_screen.dart';
import 'package:workout_player/screens/settings/user_feedback_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../common_widgets/show_alert_dialog.dart';
import '../../constants.dart';
import 'change_language_screen.dart';
import 'personal_information_screen.dart';

Logger logger = Logger();

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
    this.database,
    this.auth,
  }) : super(key: key);

  final Database database;
  final AuthBase auth;

  static void show(BuildContext context, {User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => SettingsScreen(
          database: database,
          auth: auth,
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
      title: S.current.logout,
      content: S.current.confirmSignOutContext,
      cancelAcitionText: S.current.cancel,
      defaultActionText: S.current.logout,
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
        brightness: Brightness.dark,
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
        title: Text(S.current.settingsScreenTitle, style: Subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<User>(
        initialData: userDummyData,
        stream: widget.database.userStream(widget.auth.currentUser.uid),
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
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      S.current.personalInformation,
                      style: BodyText2,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                    onTap: () => PersonalInformationScreen.show(
                      context: context,
                      user: user,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.straighten_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.unitOfMass, style: BodyText2),
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
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.white),
                    title: Text(
                      S.current.FeedbackAndFeatureRequests,
                      style: BodyText2,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                    onTap: () => UserFeedbackScreen.show(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.about, style: BodyText2),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      // TODO: Update Version Number
                      showAboutDialog(
                        context: context,
                        applicationName: S.current.applicationName,
                        applicationVersion: '0.1.4+2',
                        applicationIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Image.asset(
                            'assets/logos/playerh_logo.png',
                            width: 36,
                            height: 36,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.language_rounded,
                      color: Colors.white,
                    ),
                    title: Text(S.current.launguage, style: BodyText2),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Intl.getCurrentLocale(),
                          style: BodyText2Grey,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    onTap: () => ChangeLanguageScreen.show(context),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MaxWidthRaisedButton(
                      width: double.infinity,
                      buttonText: S.current.logout,
                      color: Grey700,
                      onPressed: () => _confirmSignOut(context),
                    ),
                  ),
                  const SizedBox(height: 38),
                ],
              ),
            ),
          );
        });
  }
}
