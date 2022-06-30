import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_player/features/nav_stack.dart';
import 'package:workout_player/features/settings/settings_screen.dart';
import 'package:workout_player/features/sign_in/sign_in_screen.dart';
import 'package:workout_player/features/sign_in/sign_in_with_email_screen.dart';
import 'package:workout_player/features/sign_in/sign_up_with_email_screen.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/routes/nav_tab_item.dart';
import 'package:workout_player/features/preview/preview_screen.dart';

enum AppRoutes {
  initial,
  app,
  preview,
  signIn,
  signInWithEmail,
  signUpWithEmail,
  settings,
}

GoRouter buildGoRouter(BuildContext context, WidgetRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      buildRoutes(AppRoutes.initial, ref: ref),
      buildRoutes(
        AppRoutes.app,
        routes: [
          buildRoutes(AppRoutes.settings),
        ],
      ),
      buildRoutes(
        AppRoutes.preview,
        routes: [
          buildRoutes(
            AppRoutes.signIn,
            routes: [
              buildRoutes(AppRoutes.signInWithEmail),
              buildRoutes(AppRoutes.signUpWithEmail),
            ],
          ),
        ],
      ),
    ],
    redirect: (state) {
      return null;
    },
    errorBuilder: (context, state) => Container(),

    // show the current router location as the user navigates page to page; note
    // that this is not required for nested navigation but it is useful to show
    // the location as it changes
    navigatorBuilder: (context, state, child) => Material(
      child: Column(
        children: [
          Expanded(child: child),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(state.location),
          ),
        ],
      ),
    ),
  );
}

GoRoute buildRoutes(
  AppRoutes appRoutes, {
  List<GoRoute> routes = const [],
  WidgetRef? ref,
  BuildContext? context,
}) {
  switch (appRoutes) {
    case AppRoutes.initial:
      return GoRoute(
        path: '/',
        redirect: (state) {
          if (ref == null) return null;

          final auth = ref.watch(firebaseAuthProvider);

          if (auth.currentUser == null) {
            return '/preview';
          } else {
            return '/app/${NavTabItem.move.name}';
          }
        },
      );
    case AppRoutes.app:
      return GoRoute(
        path: '/app/:navTab',
        name: AppRoutes.app.name,
        builder: (context, state) {
          final tabName = state.params['navTab']!;

          final tabItem = NavTabItem.values.firstWhere(
            (item) => item.name == tabName,
            orElse: () => NavTabItem.move,
          );

          return NavStack(currentNavTab: tabItem);
        },
        routes: routes,
      );
    case AppRoutes.preview:
      return GoRoute(
        path: '/preview',
        name: AppRoutes.preview.name,
        builder: (context, state) => const PreviewScreen(),
        routes: routes,
      );
    case AppRoutes.signIn:
      return GoRoute(
        path: 'signIn',
        name: AppRoutes.signIn.name,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionsBuilder: (context, animation, _, __) {
              return FadeTransition(
                opacity: animation,
                child: SignInScreen(animation: animation),
              );
            },
            child: const SizedBox.shrink(),
          );
        },
        routes: routes,
      );
    case AppRoutes.signInWithEmail:
      return GoRoute(
        path: AppRoutes.signInWithEmail.name,
        name: AppRoutes.signInWithEmail.name,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            transitionsBuilder: (context, animation, _, __) => FadeTransition(
              opacity: animation,
              child: SignInWithEmailScreen(animation: animation),
            ),
            child: const SizedBox.shrink(),
          );
        },
      );
    case AppRoutes.signUpWithEmail:
      return GoRoute(
        path: AppRoutes.signUpWithEmail.name,
        name: AppRoutes.signUpWithEmail.name,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SizedBox.shrink(),
            transitionsBuilder: (context, animation, _, __) => FadeTransition(
              opacity: animation,
              child: SignUpWithEmailScreen(animation: animation),
            ),
          );
        },
      );
    case AppRoutes.settings:
      return GoRoute(
        path: AppRoutes.settings.name,
        name: AppRoutes.settings.name,
        pageBuilder: (context, state) {
          return MaterialPage(
            fullscreenDialog: false,
            child: const SettingsScreen(),
            name: AppRoutes.settings.name,
          );
        },
      );
  }
}
