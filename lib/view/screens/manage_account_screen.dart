import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'change_display_name_screen.dart';
import 'delete_account_screen.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Database database;
  final User user;

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => ManageAccountScreen(
        database: database,
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: Text(S.current.manageAccount, style: TextStyles.subtitle1),
            backgroundColor: ThemeColors.appBar,
            flexibleSpace: const AppbarBlurBG(),
            leading: const AppBarBackButton(),
          ),
          SliverToBoxAdapter(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<User?>(
      initialData: user,
      stream: database.userStream(),
      builder: (context, snapshot) {
        final userData = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.personalInformation,
                style: TextStyles.body2GreyBold,
              ),
            ),
            ListTile(
              title: Text(
                S.current.displayName,
                style: TextStyles.body2,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userData!.displayName,
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
              onTap: () => ChangeDisplayNameScreen.show(
                context,
                user: userData,
              ),
            ),
            // ListTile(
            //   title: Text(S.current.email, style: kBodyText2),
            //   trailing: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       if (user.userEmail != null)
            //         Text(
            //           user.userEmail,
            //           style: kBodyText2Grey,
            //         ),
            //       const SizedBox(width: 16),
            //       const Icon(
            //         Icons.arrow_forward_ios_rounded,
            //         color: Colors.grey,
            //         size: 20,
            //       ),
            //     ],
            //   ),
            //   onTap: () => ChangeEmailScreen.show(
            //     context,
            //     user: user,
            //   ),
            // ),
            kCustomDivider,
            ListTile(
              onTap: () => DeleteAccountScreen.show(context, user: userData),
              title: Text(
                S.current.deleteAcocunt,
                style: TextStyles.body2,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}
