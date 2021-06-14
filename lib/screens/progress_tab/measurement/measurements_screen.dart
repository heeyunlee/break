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
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../styles/constants.dart';

class MeasurementsScreen extends StatelessWidget {
  final Database database;
  final User user;

  const MeasurementsScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.getUserDocument(auth.currentUser!.uid);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MeasurementsScreen(
          database: database,
          user: user!,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Measurement measurement) async {
    try {
      await database.deleteMeasurement(measurement: measurement);

      getSnackbarWidget(
        S.current.deleteMeasurementSnackbarTitle,
        S.current.deleteMeasurementSnackbar,
      );
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
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(S.current.bodyMeasurement, style: kSubtitle2),
        centerTitle: true,
        brightness: Brightness.dark,
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
        query: database.measurementsQuery(),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContent(
          message: S.current.measurementsEmptyMessage,
        ),
        header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
        footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),
        onError: (error) => EmptyContent(
          message: '${S.current.somethingWentWrong}: $error',
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (index, context, documentSnapshot) {
          // final documentId = documentSnapshot.id;
          // final data = documentSnapshot.data();
          // final measurement = Measurement.fromMap(data!, documentId);
          // final snapshot = documentSnapshot as DocumentSnapshot<Measurement?>;
          // final measurement = snapshot.data()!;
          final measurement = documentSnapshot.data()! as Measurement;

          final date = Formatter.yMdjm(measurement.loggedTime);

          final unit = Formatter.unitOfMass(user.unitOfMass);

          return Slidable(
            // startActionPane: const SlidableDrawerActionPane(),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  label: S.current.delete,
                  backgroundColor: Colors.red,
                  icon: Icons.delete_rounded,
                  onPressed: (context) => _delete(context, measurement),
                ),
              ],
            ),
            child: ListTile(
              leading: Text(
                '${measurement.bodyWeight}$unit',
                style: kBodyText1,
              ),
              trailing: Text(date, style: kBodyText1Grey),
            ),
          );
        },
        isLive: true,
      ),
    );
  }
}
