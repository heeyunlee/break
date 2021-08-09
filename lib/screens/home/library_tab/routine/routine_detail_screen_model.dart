import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:provider/provider.dart' as provider;

import 'routine_detail_screen.dart';

final routineDetailScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => RoutineDetailScreenModel(),
);

class RoutineDetailScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  RoutineDetailScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  late AnimationController _textAnimationController;
  late Animation<Offset> _transTween;
  late Animation<double> _opacityTween;
  late ScrollController _scrollController;

  AnimationController get textAnimationController => _textAnimationController;
  Animation<Offset> get transTween => _transTween;
  Animation<double> get opacityTween => _opacityTween;
  ScrollController get scrollController => _scrollController;

  void init(TickerProvider vsync) {
    _textAnimationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: 0),
    );

    _transTween = Tween(begin: Offset(0, 24), end: Offset(0, 0))
        .animate(_textAnimationController);

    _opacityTween =
        Tween<double>(begin: 0, end: 1).animate(_textAnimationController);

    _scrollController = ScrollController()
      ..addListener(() {
        _textAnimationController
            .animateTo((_scrollController.offset - 336) / 100);
      });
  }

  // For Navigation
  static Future<void> show(
    BuildContext context, {
    required Routine routine,
    required String tag,
    bool isPushReplacement = false,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    await HapticFeedback.mediumImpact();

    if (!isPushReplacement) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          fullscreenDialog: false,
          builder: (context) => Consumer(
            builder: (context, watch, child) => RoutineDetailScreen(
              routine: routine,
              tag: tag,
              model: watch(routineDetailScreenModelProvider),
              auth: auth,
              database: database,
            ),
          ),
        ),
      );
    } else {
      await Navigator.of(context, rootNavigator: false).pushReplacement(
        CupertinoPageRoute(
          fullscreenDialog: false,
          builder: (context) => Consumer(
            builder: (context, watch, child) => RoutineDetailScreen(
              routine: routine,
              tag: tag,
              model: watch(routineDetailScreenModelProvider),
              auth: auth,
              database: database,
            ),
          ),
        ),
      );
    }
  }
}
