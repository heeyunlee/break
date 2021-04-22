import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings_tab/unit_of_mass_screen.dart';
import 'package:workout_player/screens/settings_tab/user_feedback_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../common_widgets/show_alert_dialog.dart';
import '../../constants.dart';
import 'change_language_screen.dart';
import 'manage_account_screen.dart';

Logger logger = Logger();

class SettingsTab extends StatelessWidget {
  Future<void> _signOut(BuildContext context, AuthBase auth) async {
    try {
      // FirebaseCrashlytics.instance.crash();
      await auth.signOut();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context, AuthBase auth) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: S.current.logout,
      content: S.current.confirmSignOutContext,
      cancelAcitionText: S.current.cancel,
      defaultActionText: S.current.logout,
    );
    if (didRequestSignOut == true) {
      return _signOut(context, auth);
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
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.close_rounded,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        title: Text(S.current.settingsScreenTitle, style: Subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<User>(
        initialData: userDummyData,
        stream: database.userStream(auth.currentUser.uid),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(S.current.account, style: BodyText2BoldGrey),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      S.current.manageAccount,
                      style: BodyText2,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () => ManageAccountScreen.show(context, user: user),
                  ),
                  CustomDivider,
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
                          size: 20,
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
                      size: 20,
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
                      size: 20,
                    ),
                    onTap: () {
                      // TODO: Update Version Number
                      showAboutDialog(
                        context: context,
                        applicationName: S.current.applicationName,
                        applicationVersion: '0.2.1',
                        applicationIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          child: Image.asset(
                            'assets/logos/herakless_logo.png',
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
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () => ChangeLanguageScreen.show(context),
                  ),
                  CustomDivider,
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(S.current.logIn, style: BodyText2BoldGrey),
                  ),
                  ListTile(
                    onTap: () => _confirmSignOut(context, auth),
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: Text(S.current.logout, style: BodyText2),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        });
  }
}
