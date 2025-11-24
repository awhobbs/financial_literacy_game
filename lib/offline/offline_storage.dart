import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class OfflineStorage {
  static const String gameBoxName = "game_state_box";
  static const String queueBoxPrefix = "queue_box_"; // per-UID queues
  static const String sessionKey = "current_session_id";

  static Box? _gameBox;
  static Box? _queueBox;
  static String? _activeUID;

  // ------------------------------------------------------------
  // 🔧 INIT HIVE
  // ------------------------------------------------------------
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // Main game state box (per device)
    _gameBox = await Hive.openBox(gameBoxName);
  }

  // ------------------------------------------------------------
  // 🔥 SET ACTIVE USER (creates per-UID queue box)
  // ------------------------------------------------------------
  static Future<void> setActiveUID(String uid) async {
    _activeUID = uid;
    _queueBox = await Hive.openBox(queueBoxPrefix + uid);
  }

  // ------------------------------------------------------------
  // 🎮 SAVE SIMPLE GAME STATE (NO JSON)
  // ------------------------------------------------------------
  static Future<void> saveSimpleState(Map<String, dynamic> map) async {
    if (_gameBox == null) return;

    if (map["cash"] != null) _gameBox!.put("cash", map["cash"]);
    if (map["levelId"] != null) _gameBox!.put("levelId", map["levelId"]);
    if (map["period"] != null) _gameBox!.put("period", map["period"]);
    if (map["locale"] != null) _gameBox!.put("locale", map["locale"]);
  }

  static Map<String, dynamic> loadSimpleState() {
    if (_gameBox == null) return {};

    return {
      "cash": _gameBox!.get("cash"),
      "levelId": _gameBox!.get("levelId"),
      "period": _gameBox!.get("period"),
      "locale": _gameBox!.get("locale"),
    };
  }

  // ------------------------------------------------------------
  // 🧹 CLEAR SIMPLE GAME STATE
  // ------------------------------------------------------------
  static Future<void> clearSimpleState() async {
    if (_gameBox == null) return;

    await _gameBox!.delete("cash");
    await _gameBox!.delete("levelId");
    await _gameBox!.delete("period");
    await _gameBox!.delete("locale");
  }

  // ------------------------------------------------------------
  // 📌 OFFLINE QUEUE SUPPORT (USED IN OfflineQueue)
  // ------------------------------------------------------------
  static List<Map<String, dynamic>> loadQueue() {
    if (_queueBox == null) return [];
    return List<Map<String, dynamic>>.from(_queueBox!.get("items") ?? []);
  }

  static Future<void> saveQueue(List<Map<String, dynamic>> list) async {
    if (_queueBox == null) return;
    await _queueBox!.put("items", list);
  }

  static Future<void> clearQueue() async {
    if (_queueBox == null) return;
    await _queueBox!.delete("items");
  }

  // ------------------------------------------------------------
  // 🗑 CLEAR ALL LOCAL DATA (used on SIGN-OUT)
  // ------------------------------------------------------------
  static Future<void> clearAll() async {
    if (_gameBox != null) await _gameBox!.clear();
    if (_queueBox != null) await _queueBox!.clear();
  }
}
