import 'offline_storage.dart';

/// OfflineQueue handles per-UID action storage
/// (works together with OfflineStorage + Hive, no JSON required)
class OfflineQueue {
  final String uid;


  OfflineQueue(this.uid) {
    // Ensure correct Hive queue box is opened for this UID
    OfflineStorage.setActiveUID(uid);
  }

  /// Add a single pending action
  Future<void> add(Map<String, dynamic> action) async {
    final current = OfflineStorage.loadQueue();
    current.add(action);
    await OfflineStorage.saveQueue(current);
  }

  /// Return all queued actions for this UID
  List<Map<String, dynamic>> getAll() {
    return OfflineStorage.loadQueue();
  }

  /// Clear actions after successful sync
  Future<void> clear() async {
    await OfflineStorage.
    clearQueue();
  }
}


