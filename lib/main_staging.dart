import 'package:auth_repository/auth_repository.dart';
import 'package:cheaters_dice/app/app.dart';
import 'package:cheaters_dice/bootstrap.dart';
import 'package:cheaters_dice/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_repository/game_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final gameRepository = GameRepository();
  //await gameRepository.init(useDummy: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final db = FirebaseFirestore.instance;

  await bootstrap(
    () => App(
      authRepository: AuthRepository(firebaseDB: db),
      gameRepository: gameRepository,
    ),
  );
}
