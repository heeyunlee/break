import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

Logger logger = Logger();

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
      await database.deleteMeasurement(
        uid: user.userId,
        measurement: measurement,
      );

      // // Snackbar
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(S.current.deleteMeasurementSnackbar),
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
        query: database.measurementsQuery(user.userId),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContent(
          message: S.current.measurementsEmptyMessage,
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
          final measurement = Measurement.fromMap(data!, documentId);
          final date = Format.yMdjm(measurement.loggedTime);

          final unit = Format.unitOfMass(user.unitOfMass);

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
