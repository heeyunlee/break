import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import 'change_display_name_screen.dart';
// import 'change_email_screen.dart';
import 'delete_account_screen.dart';

Logger logger = Logger();

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({
    Key? key,
    required this.database,
    required this.auth,
  }) : super(key: key);

  final Database database;
  final AuthBase auth;

  static void show(BuildContext context, {required User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: false).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ManageAccountScreen(
          database: database,
          auth: auth,
        ),
      ),
    );
  }

  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        flexibleSpace: AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(S.current.manageAccount, style: kSubtitle1),
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
        stream: widget.database.userStream(widget.auth.currentUser!.uid),
        builder: (context, snapshot) {
          final user = snapshot.data;

          // print(user);

          // var context2 = context;
          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      S.current.personalInformation,
                      style: kBodyText2BoldGrey,
                    ),
                  ),
                  ListTile(
                    title: Text(S.current.displayName, style: kBodyText2),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // if (user!.displayName != null)
                        Text(
                          user!.displayName,
                          style: kBodyText2Grey,
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
                    title: Text(S.current.deleteAcocunt, style: kBodyText2),
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
        });
  }
}
