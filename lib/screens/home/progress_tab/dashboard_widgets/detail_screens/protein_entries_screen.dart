import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/nutrition.dart';
import 'package:workout_player/services/database.dart';

class ProteinEntriesScreen extends StatelessWidget {
  final Database database;
  final User user;

  const ProteinEntriesScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {required User user}) async {
    final database = Provider.of<Database>(context, listen: false);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProteinEntriesScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Nutrition nutrition) async {
    try {
      // Cloud Firestore Callback
      await database.deleteNutrition(nutrition);

      getSnackbarWidget(
        S.current.deleteProteinSnackbarTitle,
        S.current.deleteProteinSnackbar,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(S.current.proteinEntriesTitle, style: TextStyles.subtitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarBackButton(),
      ),
      body: PaginateFirestore(
        shrinkWrap: true,
        itemsPerPage: 10,
        query: database.proteinsPaginatedUserQuery(),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContent(
          message: S.current.proteinEntriesEmptyMessage,
        ),
        header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
        footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),
        onError: (error) => EmptyContent(
          message: '${S.current.somethingWentWrong}: $error',
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (index, context, snapshot) {
          final nutrition = snapshot.data() as Nutrition;
          final date = Formatter.yMdjm(nutrition.loggedTime);
          final title = Formatter.numWithDecimal(nutrition.proteinAmount);

          final unit = Formatter.unitOfMass(
            user.unitOfMass,
            user.unitOfMassEnum,
          );

          return Slidable(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  label: S.current.delete,
                  backgroundColor: Colors.red,
                  icon: Icons.delete_rounded,
                  onPressed: (context) => _delete(context, nutrition),
                ),
              ],
            ),
            child: ListTile(
              leading: Text(
                '$title $unit',
                style: TextStyles.body1,
              ),
              trailing: Text(date, style: TextStyles.body1_grey),
            ),
          );
        },
        isLive: true,
      ),
    );
  }
}
