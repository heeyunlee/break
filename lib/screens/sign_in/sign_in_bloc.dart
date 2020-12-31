import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';

// class SignInBloc {
//   SignInBloc({@required this.auth});
//
//   final AuthServiceProvider auth;
//
//   final StreamController<bool> _isLoadingController = StreamController<bool>();
//
//   Stream<bool> get isLoadingStream => _isLoadingController.stream;
//
//   void dispose() {
//     _isLoadingController.close();
//   }
//
//   void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
//
//   Future<bool> _signIn(
//       Future<bool> Function(BuildContext context) signInMethod) async {
//     try {
//       _setIsLoading(true);
//       BuildContext context;
//       return await signInMethod(context);
//     } catch (e) {
//       _setIsLoading(false);
//       rethrow;
//     }
//   }
//
//   Future<bool> signInWithGoogle() => _signIn(auth.signInWithGoogle);
//
//   Future<bool> signInWithFacebook() async =>
//       await _signIn(auth.signInWithFacebook);
//   Future<bool> signInWithApple() async => await _signIn(auth.signInWithApple);
// }

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(
      Future<User> Function(BuildContext context) signInMethod) async {
    try {
      isLoading.value = true;
      BuildContext context;
      return await signInMethod(context);
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
