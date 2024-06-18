// ignore_for_file: unnecessary_parenthesis

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:lobby_repository/lobby_repository.dart';

class LobbyRepository {
  LobbyRepository();

  Future<Lobby?> getLobbyById({
    required String lobbyId,
  }) async {
    if (lobbyId == '') {
      return null;
    } else {
      final lobbyRef = lobbyDoc(docId: lobbyId);

      try {
        return await lobbyRef.get().then(
          (doc) {
            return doc.data();
          },
          onError: (dynamic e) => debugPrint('Error completing: $e'),
        );
      } catch (err) {
        debugPrint('Error while retrieving lobby: $err');
        return null;
      }
    }
  }

  Future<void> updateLobbyById({
    required String lobbyId,
    required Map<String, dynamic> data,
  }) async {
    if (lobbyId == '') return;
    final lobbyRef = lobbyDoc(docId: lobbyId);

    try {
      await lobbyRef.update(data);
    } catch (err) {
      debugPrint('Error while updating lobby: $err');
    }
  }

  Future<StreamSubscription<DocumentSnapshot<Lobby>>?> getLobbyStream({
    required String lobbyId,
    required void Function(Lobby? game) onData,
  }) async {
    return lobbyDoc(docId: lobbyId).snapshots().listen(
          (event) => onData(event.data()),
          onError: (dynamic error) => debugPrint('Listen failed: $error'),
        );
  }
}
