import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/game/view/game_page.dart';
import 'package:cheaters_dice/home/view/home_page.dart';
import 'package:cheaters_dice/leaderboard/view/views.dart';
import 'package:cheaters_dice/lobby/view/views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter mainRouter(AuthState authState) => GoRouter(
      //navigatorKey: onBoardingNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          //builder: (context, state) => const LobbyPage(),
          pageBuilder: (context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 1000),
              transitionsBuilder: (
                context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/lobby',
          pageBuilder: (context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LobbyPage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (
                context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/leaderboard',
          pageBuilder: (context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LeaderboardPage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder: (
                context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: 'lobby',
          path: '/lobby/:lobbyId',
          builder: (context, state) => JoinedLobbyPage(
            lobbyId: state.pathParameters['lobbyId'] ?? '',
          ),
        ),
        GoRoute(
          name: 'lobby_settings',
          path: '/lobby/:lobbyId/settings',
          builder: (context, state) => LobbySettingPage(
            lobbyId: state.pathParameters['lobbyId'] ?? '',
          ),
        ),
        GoRoute(
          name: 'game',
          path: '/game/:gameId',
          //builder: (context, state) => const GamePage(),
          pageBuilder: (context, GoRouterState state) {
            final gameId = state.pathParameters['gameId'];

            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: GamePage(gameId: gameId!),
              transitionDuration: const Duration(milliseconds: 1000),
              transitionsBuilder: (
                context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(
                  opacity:
                      CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
      redirect: (context, GoRouterState state) {
        // if the user is not logged in, they need to login
        final loggedIn = authState.user != null;
        final loggingIn = state.matchedLocation == '/login';
        if (!loggedIn) {
          return '/login';
        }

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (loggingIn) {
          return '/';
        }

        // no need to redirect at all
        return null;
      },

      // changes on the listenable will cause the router to refresh it's route
    );
