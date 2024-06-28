import 'package:auth_repository/auth_repository.dart';
import 'package:cheaters_dice/app/app.dart';
import 'package:cheaters_dice/bootstrap.dart';
import 'package:cheaters_dice/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:game_repository/game_repository.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:lobby_repository/lobby_repository.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final gameRepository = GameRepository();
  //await gameRepository.init(useDummy: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final db = FirebaseFirestore.instance;
  final lobbyRepository = LobbyRepository();
  final leaderboardRepository = LeaderboardRepository();

  await bootstrap(
    () => App(
      authRepository: AuthRepository(firebaseDB: db),
      gameRepository: gameRepository,
      lobbyRepository: lobbyRepository,
      leaderboardRepository: leaderboardRepository,
    ),
  );
}
