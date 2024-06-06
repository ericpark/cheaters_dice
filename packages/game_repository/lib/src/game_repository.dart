// ignore_for_file: unnecessary_parenthesis

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:game_repository/game_repository.dart';

class GameRepository {
  GameRepository();

  Future<Game?> getGameById({
    required String gameId,
  }) async {
    if (gameId == '') {
      return null;
    } else {
      final gameRef = gameDoc(docId: gameId);

      try {
        return await gameRef.get().then(
          (doc) {
            return doc.data();
          },
          onError: (dynamic e) => debugPrint('Error completing: $e'),
        );
      } catch (err) {
        debugPrint('Error while retrieving games: $err');
        return null;
      }
    }
  }

  Future<StreamSubscription<DocumentSnapshot<Game>>?> getGameStream({
    required String gameId,
    required void Function(Game? game) onData,
  }) async {
    return gameDoc(docId: gameId).snapshots().listen(
          (event) => onData(event.data()),
          onError: (dynamic error) => debugPrint('Listen failed: $error'),
        );
  }

  Future<bool> addPlayerAction({required Action playerAction}) async {
    final playerActionsCollectionRef =
        (actionCollection('games/${playerAction.gameId}/actions'));

    try {
      final playerActionId = await playerActionsCollectionRef
          .add(playerAction)
          .then((documentSnapshot) => documentSnapshot.id);

      final updated = await updatePlayerAction(
        gameId: playerAction.gameId,
        playerActionId: playerActionId,
        data: {'id': playerActionId},
      );

      return updated != null;
    } catch (err) {
      debugPrint('Error while adding player action: $err');
      return false;
    }
  }

  Future<Action?> updatePlayerAction({
    required String gameId,
    required String playerActionId,
    required Map<String, dynamic> data,
  }) async {
    final playerActionsDocRef =
        actionDoc(path: 'games/$gameId/actions', docId: playerActionId);

    final query = playerActionsDocRef;

    try {
      return await query.update(data).then(
        (_) async {
          return query.get().then((doc) {
            return doc.data();
          });
        },
        onError: (dynamic e) => debugPrint('Error completing: $e'),
      );
    } catch (err) {
      debugPrint('Error while updating player action: $err');
      return null;
    }
  }
}
