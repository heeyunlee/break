import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/material.dart';
import 'package:workout_player/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<fireAuth.User> _signIn(
      Future<fireAuth.User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<fireAuth.User> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
  Future<fireAuth.User> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
  Future<fireAuth.User> signInWithApple() async =>
      await _signIn(auth.signInWithApple);
}
