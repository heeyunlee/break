import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

final routineDetailScreenModelProvider = ChangeNotifierProvider(
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
}
