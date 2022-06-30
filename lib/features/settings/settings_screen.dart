import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/services/firebase_auth_service.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/settings_tab_model.dart';

import '../screens/manage_account_screen.dart';
import '../screens/personal_goals_screen.dart';
import '../screens/unit_of_mass_screen.dart';
import '../screens/user_feedback_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(settingsTabModelProvider);
    final database = ref.watch(databaseProvider);
    final auth = ref.watch(firebaseAuthProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: Text(
              S.current.settingsScreenTitle,
              style: TextStyles.subtitle2,
            ),
            leading: const AppBarBackButton(),
          ),
          SliverToBoxAdapter(
            child: _buildBody(context, model, database, auth),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SettingsTabModel model,
    Database database,
    FirebaseAuthService auth,
  ) {
    return CustomStreamBuilder<User?>(
      stream: database.userStream(),
      builder: (context, user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.current.account,
              style: TextStyles.body2GreyBold,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: Text(
              S.current.manageAccount,
              style: TextStyles.body2,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () => ManageAccountScreen.show(
              context,
              user: user!,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.straighten_rounded,
              color: Colors.white,
            ),
            title: Text(
              S.current.unitOfMass,
              style: TextStyles.body2,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatter.unitOfMass(user!.unitOfMass, user.unitOfMassEnum),
                  style: TextStyles.body2Grey,
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
              context,
              user: user,
            ),
          ),

          // // LANGUAGE
          // ListTile(
          //   leading: const Icon(
          //     Icons.language_rounded,
          //     color: Colors.white,
          //   ),
          //   title: Text(
          //     S.current.launguage,
          //     style: TextStyles.body2,
          //   ),
          //   trailing: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text(
          //         Intl.getCurrentLocale(),
          //         style: TextStyles.body2Grey,
          //       ),
          //       const SizedBox(width: 16),
          //       const Icon(
          //         Icons.arrow_forward_ios_rounded,
          //         color: Colors.grey,
          //         size: 20,
          //       ),
          //     ],
          //   ),
          //   onTap: () => ChangeLanguageScreen.show(context),
          // ),

          // PERSONAL GOALS
          ListTile(
            leading: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
            ),
            title: Text(
              S.current.personalGoals,
              style: TextStyles.body2,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () => PersonalGoalsScreen.show(context),
          ),

          // SUPPORT
          kCustomDivider,
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.current.support,
              style: TextStyles.body2GreyBold,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.white),
            title: Text(
              S.current.FeedbackAndFeatureRequests,
              style: TextStyles.body2,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () => UserFeedbackScreen.show(context, user: user),
          ),

          // ABOUT
          kCustomDivider,
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.current.about,
              style: TextStyles.body2GreyBold,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
            title: Text(S.current.about, style: TextStyles.body2),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () => model.showAboutDialogOfApp(context),
          ),
          ListTile(
            leading: const Icon(
              Icons.policy_outlined,
              color: Colors.white,
            ),
            title: Text(
              S.current.privacyPolicy,
              style: TextStyles.body2,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () async {
              final canLaunchs = await canLaunch(privacyPolicyUrl);

              if (canLaunchs) {
                await launch(privacyPolicyUrl);
              } else {
                if (!mounted) return;

                await showExceptionAlertDialog(
                  context,
                  title: S.current.operationFailed,
                  exception: S.current.couldNotLaunch(privacyPolicyUrl),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.description_rounded,
              color: Colors.white,
            ),
            title: Text(S.current.terms, style: TextStyles.body2),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
            // onTap: () => MainModel().launchTermsURL(context),
            onTap: () async {
              final canLaunchs = await canLaunch(termsUrl);

              if (canLaunchs) {
                await launch(termsUrl);
              } else {
                if (!mounted) return;

                await showExceptionAlertDialog(
                  context,
                  title: S.current.operationFailed,
                  exception: S.current.couldNotLaunch(termsUrl),
                );
              }
            },
          ),

          // LOG IN
          kCustomDivider,
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.current.logIn,
              style: TextStyles.body2GreyBold,
            ),
          ),
          ListTile(
            // onTap: () => model.confirmSignOut(context),
            onTap: () async {
              final didRequestSignOut = await showAlertDialog(
                context,
                title: S.current.logout,
                content: S.current.confirmSignOutContext,
                cancelAcitionText: S.current.cancel,
                defaultActionText: S.current.logout,
              );

              if (didRequestSignOut == true) {
                try {
                  await auth.signOut();

                  if (!mounted) return;

                  Navigator.of(context).popUntil((route) => route.isFirst);

                  // getSnackbarWidget(
                  //   S.current.signOutSnackbarTitle,
                  //   S.current.signOutSnackbarMessage,
                  // );
                } catch (e) {
                  if (!mounted) return;

                  await showExceptionAlertDialog(
                    context,
                    title: S.current.operationFailed,
                    exception: S.current.signOutFailedMessage,
                  );
                }
              }
            },
            leading: const Icon(Icons.logout, color: Colors.white),
            title: Text(S.current.logout, style: TextStyles.body2),
          ),
          const SizedBox(height: 48),
          // TODO: CHANGE VERSION CODE HERE
          const Center(
            child: Text('v.0.3.8', style: TextStyles.caption1Grey),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
