import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view/widgets/dialogs.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';

/// Creates a screen that displays a list of [Nutrition] entries, created by
/// the user.
///
/// ## Roadmap
///
/// ### Refactoring
/// * TODO: Paginate list of [Nutrition] stream
///
/// ### Enhancement
///
class FatEntriesScreen extends StatelessWidget {
  final Database database;
  final User user;

  const FatEntriesScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => FatEntriesScreen(
        database: database,
        user: user,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(S.current.bodyFat, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: CustomStreamBuilder<List<Nutrition>>(
        stream: database.userNutritionStream(limit: 100),
        builder: (context, data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 8),
                CustomListViewBuilder<Nutrition>(
                  items: data,
                  itemBuilder: (context, nutrition, i) {
                    final date = Formatter.yMdjm(nutrition.loggedTime);
                    final title = Formatter.numWithDecimal(nutrition.fat);
                    final unit = Formatter.unitOfMass(
                      user.unitOfMass,
                      user.unitOfMassEnum,
                    );

                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
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
                        trailing: Text(date, style: TextStyles.body1Grey),
                      ),
                    );
                  },
                ),
                const SizedBox(height: kBottomNavigationBarHeight),
              ],
            ),
          );
        },
      ),
      // body: PaginateFirestore(
      //   shrinkWrap: true,
      //   itemsPerPage: 10,
      //   query: database.carbsPaginatedUserQuery(),
      //   itemBuilderType: PaginateBuilderType.listView,
      //   emptyDisplay: EmptyContent(
      //     message: S.current.proteinEntriesEmptyMessage,
      //   ),
      //   header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
      //   footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),
      //   onError: (error) => EmptyContent(
      //     message: '${S.current.somethingWentWrong}: $error',
      //   ),
      //   physics: const BouncingScrollPhysics(),
      //   itemBuilder: (index, context, snapshot) {
      //     final nutrition = snapshot.data() as Nutrition?;
      //     final date = Formatter.yMdjm(nutrition!.loggedTime);
      //     final title = Formatter.numWithDecimal(nutrition.fat);
      //     final unit = Formatter.unitOfMass(
      //       user.unitOfMass,
      //       user.unitOfMassEnum,
      //     );

      //     return Slidable(
      //       endActionPane: ActionPane(
      //         motion: const ScrollMotion(),
      //         children: [
      //           SlidableAction(
      //             label: S.current.delete,
      //             backgroundColor: Colors.red,
      //             icon: Icons.delete_rounded,
      //             onPressed: (context) => _delete(context, nutrition),
      //           ),
      //         ],
      //       ),
      //       child: ListTile(
      //         leading: Text(
      //           '$title $unit',
      //           style: TextStyles.body1,
      //         ),
      //         trailing: Text(date, style: TextStyles.body1Grey),
      //       ),
      //     );
      //   },
      //   isLive: true,
      // ),
    );
  }
}
