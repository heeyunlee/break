import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class CaloriesEntriesScreen extends ConsumerWidget {
  const CaloriesEntriesScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  static void show(
    BuildContext context, {
    required User user,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => CaloriesEntriesScreen(user: user),
    );
  }

  Future<void> _delete(
    BuildContext context,
    Nutrition nutrition,
    Database database,
  ) async {
    try {
      // Cloud Firestore Callback
      await database.deleteNutrition(nutrition);

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
    final database = ref.watch(databaseProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(S.current.proteinEntriesTitle, style: TextStyles.subtitle2),
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
                    final title = Formatter.numWithDecimal(nutrition.calories);

                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: S.current.delete,
                            backgroundColor: Colors.red,
                            icon: Icons.delete_rounded,
                            onPressed: (context) =>
                                _delete(context, nutrition, database),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Text(
                          '$title Kcal',
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
    );
  }
}
