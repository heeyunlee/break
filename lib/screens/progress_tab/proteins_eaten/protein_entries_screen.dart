import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

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
      // Update User Data
      final nutritions = user.dailyNutritionHistories;
      final index = user.dailyNutritionHistories!.indexWhere(
        (element) => element.date == nutrition.loggedDate,
      );

      final oldNutrition = nutritions![index];
      final newNutrition = DailyNutritionHistory(
        date: oldNutrition.date,
        totalProteins: oldNutrition.totalProteins - nutrition.proteinAmount,
      );

      nutritions[index] = newNutrition;

      final newUserData = {
        'dailyNutritionHistories': nutritions.map((e) => e.toMap()).toList(),
      };

      print(newUserData);

      // Cloud Firestore Callback
      await database.deleteNutrition(nutrition);
      await database.updateUser(user.userId, newUserData);

      // // Snackbar
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(S.current.deleteProteinSnackbar),
      //   duration: Duration(seconds: 2),
      //   behavior: SnackBarBehavior.floating,
      // ));
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(S.current.proteinEntriesTitle, style: kSubtitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: PaginateFirestore(
        shrinkWrap: true,
        itemsPerPage: 10,
        query: database.nutritionsPaginatedUserQuery(),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContent(
          message: S.current.proteinEntriesEmptyMessage,
        ),
        header: SizedBox(height: 16),
        footer: const SizedBox(height: 16),
        onError: (error) => EmptyContent(
          message: '${S.current.somethingWentWrong}: $error',
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (index, context, documentSnapshot) {
          final documentId = documentSnapshot.id;
          final data = documentSnapshot.data();
          final nutrition = Nutrition.fromMap(data!, documentId);
          final date = Format.yMdjm(nutrition.loggedTime);

          return Slidable(
            // startActionPane: const SlidableDrawerActionPane(),
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
              leading: Text('${nutrition.proteinAmount}g', style: kBodyText1),
              trailing: Text(date, style: kBodyText1Grey),
            ),
          );
        },
        isLive: true,
      ),
    );
  }
}
