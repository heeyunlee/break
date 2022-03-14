import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

/// Creates a screen that displays a list of [Measurement] entries, created by
/// the user.
///
/// ## Roadmap
///
/// ### Refactoring
/// * TODO: Paginate list of [Measurement] stream
///
/// ### Enhancement
///
class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => MeasurementsScreen(user: user),
    );
  }

  Future<void> _delete(
    BuildContext context,
    Database database,
    Measurement measurement,
  ) async {
    try {
      await database.deleteMeasurement(measurement: measurement);

      getSnackbarWidget(
        S.current.deleteMeasurementSnackbarTitle,
        S.current.deleteMeasurementSnackbar,
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
        title: Text(S.current.bodyMeasurement, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: CustomStreamBuilder<List<Measurement>>(
        stream: ref.read(databaseProvider).measurementsStream(limit: 100),
        builder: (context, data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CustomListViewBuilder<Measurement>(
                  items: data,
                  itemBuilder: (context, measurement, i) {
                    final date = Formatter.yMdjm(measurement.loggedTime);

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
                              ref.read(databaseProvider),
                              measurement,
                            ),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Text(
                          '${measurement.bodyWeight}$unit',
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
      //   query: database.measurementsQuery(),
      //   itemBuilderType: PaginateBuilderType.listView,
      //   emptyDisplay: EmptyContent(
      //     message: S.current.measurementsEmptyMessage,
      //   ),
      //   header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
      //   footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),
      //   onError: (error) => EmptyContent(
      //     message: '${S.current.somethingWentWrong}: $error',
      //   ),
      //   physics: const BouncingScrollPhysics(),
      //   itemBuilder: (index, context, documentSnapshot) {
      //     final measurement = documentSnapshot.data()! as Measurement;

      //     final date = Formatter.yMdjm(measurement.loggedTime);

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
      //             onPressed: (context) => _delete(context, measurement),
      //           ),
      //         ],
      //       ),
      //       child: ListTile(
      //         leading: Text(
      //           '${measurement.bodyWeight}$unit',
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
