import 'package:auth_repository/auth_repository.dart';
import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:cheaters_dice/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class App extends StatelessWidget {
  const App({
    required AuthRepository authRepository,
    required GameRepository gameRepository,
    super.key,
  })  : _authRepository = authRepository,
        _gameRepository = gameRepository;

  final AuthRepository _authRepository;
  final GameRepository _gameRepository;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _gameRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(context.read<AuthRepository>())..init(),
          ),
          BlocProvider<GameBloc>(
            create: (BuildContext context) =>
                GameBloc(gameRepository: context.read<GameRepository>())
                  ..init(),
            lazy: false,
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state.status) {
            case AuthStatus.authenticated:
              return const GamePage();
            case AuthStatus.unauthenticated:
              return const LoginPage();
            case AuthStatus.loading:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case AuthStatus.initial:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }
}
