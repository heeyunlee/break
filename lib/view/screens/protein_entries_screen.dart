import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';

/// Creates a screen that displays a list of protein entries, created by the
/// user.
///
/// ## Roadmap
///
/// ### Refactoring
/// * TODO: Paginate Nutrition stream
///
/// ### Enhancement
///
class ProteinEntriesScreen extends ConsumerWidget {
  const ProteinEntriesScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => ProteinEntriesScreen(user: user),
    );
  }

  Future<void> _delete(
      BuildContext context, Nutrition nutrition, WidgetRef ref) async {
    try {
      // Cloud Firestore Callback
      await ref.read(databaseProvider).deleteNutrition(nutrition);

      getSnackbarWidget(
        S.current.deleteProteinSnackbarTitle,
        S.current.deleteProteinSnackbar,
      );
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.proteinEntriesTitle, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: CustomStreamBuilder<List<Nutrition>>(
        stream: ref.read(databaseProvider).userNutritionStream(limit: 100),
        emptyWidget: EmptyContent(
          message: S.current.proteinEntriesEmptyMessage,
        ),
        errorWidget: EmptyContent(
          message: S.current.somethingWentWrong,
        ),
        builder: (context, data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CustomListViewBuilder<Nutrition>(
                  items: data,
                  itemBuilder: (context, nutrition, i) {
                    final date = Formatter.yMdjm(nutrition.loggedTime);
                    final title =
                        Formatter.numWithDecimal(nutrition.proteinAmount);

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
                            onPressed: (context) => _delete(
                              context,
                              nutrition,
                              ref,
                            ),
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
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      // body: PaginateFirestore(
      //   shrinkWrap: true,
      //   itemsPerPage: 10,
      //   query: database.proteinsPaginatedUserQuery(),
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
      //     final title = Formatter.numWithDecimal(nutrition.proteinAmount);

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
