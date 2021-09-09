import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import '../../styles/constants.dart';
import 'change_display_name_screen.dart';
import 'delete_account_screen.dart';

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({
    Key? key,
    required this.database,
    // required this.auth,
  }) : super(key: key);

  final Database database;
  // final AuthBase auth;

  static void show(BuildContext context, {required User user}) {
    final database = Provider.of<Database>(context, listen: false);
    // final auth = Provider.of<AuthBase>(context, listen: false);

    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ManageAccountScreen(
          database: database,
          // auth: auth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: const AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        leading: const AppBarBackButton(),
        title: Text(S.current.manageAccount, style: TextStyles.subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<User?>(
      initialData: userDummyData,
      stream: database.userStream(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),
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
                      // if (user!.displayName != null)
                      Text(
                        user!.displayName,
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
                    user: user,
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
                const Divider(color: kGrey700, indent: 16, endIndent: 16),
                ListTile(
                  onTap: () => DeleteAccountScreen.show(context, user: user),
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
            ),
          ),
        );
      },
    );
  }
}
