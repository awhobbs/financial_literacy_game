import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'offline_queue.dart';

/// Handles background syncing of offline actions to Firestore
class OfflineSync {
  static Timer? _timer;

  /// Starts periodic sync every 10 seconds for the given UID
  static void startWorker(String uid) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
          (_) => sync(uid),
    );
  }

  /// Manually trigger sync (used at login)
  static Future<void> sync(String uid) async {
    final queue = OfflineQueue(uid);   // Queue is always bound to current UID
    final pending = queue.getAll();

    if (pending.isEmpty) return;

    for (final action in pending) {
      try {
        await _sendToFirestore(action);
      } catch (e) {
        // Stop sync on error; next cycle will retry
        return;
      }
    }

    // All successful → clear queue
    await queue.clear();
  }

  /// Writes one queued offline action to Firestore
  static Future<void> _sendToFirestore(Map<String, dynamic> action) async {
    final String collection = action["collection"];
    final Map<String, dynamic> data = action["data"];
    final String? doc = action["doc"];

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
}
