import 'package:auth_repository/auth_repository.dart';
import 'package:cheaters_dice/app/app.dart';
import 'package:cheaters_dice/bootstrap.dart';
import 'package:cheaters_dice/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:game_repository/game_repository.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //await gameRepository.init(useDummy: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final db = FirebaseFirestore.instance;
  final gameRepository = GameRepository();

  //print(await gameRepository.getGameById(gameId: '46hOQ2pQ26C4aIx6iAWF'));

  await bootstrap(
    () => App(
      authRepository: AuthRepository(firebaseDB: db),
      gameRepository: gameRepository,
    ),
  );
}
