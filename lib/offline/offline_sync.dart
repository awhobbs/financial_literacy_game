import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'offline_queue.dart';

/// Handles background syncing of offline actions to Firestore
class OfflineSync {
  static Timer? _timer;
  static const int _batchLimit = 500; // Firestore batch limit

  /// Starts periodic sync every 10 seconds for the given UID
  static void startWorker(String uid) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
          (_) => sync(uid),
    );
  }

  /// Stop the sync worker
  static void stopWorker() {
    _timer?.cancel();
    _timer = null;
  }

  /// Manually trigger sync (used at login or app resume)
  static Future<void> sync(String uid) async {
    final queue = OfflineQueue(uid);
    final pending = queue.getAll();

    if (pending.isEmpty) {
      debugPrint("Sync: No pending items for $uid");
      return;
    }

    debugPrint("Sync: ${pending.length} pending items for $uid");

    // Separate roundData actions for batching
    final roundDataActions = <Map<String, dynamic>>[];
    final otherActions = <Map<String, dynamic>>[];

    for (final action in pending) {
      if (action["collection"] == "roundData") {
        roundDataActions.add(action);
      } else {
        otherActions.add(action);
      }
    }

    try {
      // Handle roundData with batching
      if (roundDataActions.isNotEmpty) {
        await _syncRoundDataBatch(roundDataActions);
      }

      // Handle other actions individually
      for (final action in otherActions) {
        await _sendToFirestore(action);
      }

      // All successful → clear queue
      await queue.clear();
      debugPrint("Sync: Successfully synced ${pending.length} items");
    } catch (e) {
      debugPrint("Sync error: $e");
      // Queue remains for next sync attempt
    }
  }

  /// Batch sync roundData entries for efficiency
  static Future<void> _syncRoundDataBatch(
      List<Map<String, dynamic>> actions) async {
    final db = FirebaseFirestore.instance;
    final roundDataRef = db.collection('roundData');

    // Process in batches of 500 (Firestore limit)
    for (var i = 0; i < actions.length; i += _batchLimit) {
      final batchEnd =
          (i + _batchLimit < actions.length) ? i + _batchLimit : actions.length;
      final batchActions = actions.sublist(i, batchEnd);

      final batch = db.batch();

      for (final action in batchActions) {
        final data = Map<String, dynamic>.from(action["data"]);

        // Add server timestamp for sync tracking
        data['syncedAt'] = FieldValue.serverTimestamp();

        // Create new document with auto-generated ID
        final docRef = roundDataRef.doc();
        batch.set(docRef, data);
      }

      await batch.commit();
      debugPrint(
          "Batch committed: ${batchActions.length} roundData entries (batch ${(i ~/ _batchLimit) + 1})");
    }
  }

  /// Writes one queued offline action to Firestore
  static Future<void> _sendToFirestore(Map<String, dynamic> action) async {
    final String collection = action["collection"];
    final Map<String, dynamic> data = Map<String, dynamic>.from(action["data"]);
    final String? doc = action["doc"];

    // Add server timestamp
    data['syncedAt'] = FieldValue.serverTimestamp();

    final colRef = FirebaseFirestore.instance.collection(collection);

    if (doc != null && doc.isNotEmpty) {
      // Update or merge an existing document
      await colRef.doc(doc).set(
        data,
        SetOptions(merge: true),
      );
    } else {
      // Create a NEW Firestore document
      await colRef.add(data);
    }
  }

  /// Check if currently syncing
  static bool get isRunning => _timer != null && _timer!.isActive;
}
