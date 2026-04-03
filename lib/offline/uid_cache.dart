import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles offline UID validation by caching CSV data in SharedPreferences
class UIDCache {
  static const String _cacheKey = 'uid_cache';
  static const String _cacheVersionKey = 'uid_cache_version';
  static const int _currentVersion = 2;

  // ignore: prefer_final_fields
  static Set<String> _memoryCache = {};
  // ignore: prefer_final_fields
  static Map<String, Map<String, String>> _uidDataCache = {};
  static bool _isLoaded = false;

  /// Load CSV from bundled assets and cache UIDs
  /// Call this at app startup or sign-in flow
  static Future<void> loadFromCSV() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();

    // Check if we have cached data and it's current version
    final cachedVersion = prefs.getInt(_cacheVersionKey) ?? 0;
    if (cachedVersion == _currentVersion) {
      // Load from SharedPreferences cache
      final cachedUIDs = prefs.getStringList(_cacheKey);
      if (cachedUIDs != null && cachedUIDs.isNotEmpty) {
        _memoryCache = cachedUIDs.toSet();
        await _loadFullDataFromPrefs(prefs);
        _isLoaded = true;
        return;
      }
    }

    // Load fresh from CSV asset
    await _loadFromAsset(prefs);
    _isLoaded = true;
  }

  /// Load CSV data from bundled asset
  static Future<void> _loadFromAsset(SharedPreferences prefs) async {
    try {
      final csvString = await rootBundle.loadString(
        'uids/Uganda_Pilot_All_Regions.csv',
      );

      final lines = csvString.split('\n');
      if (lines.isEmpty) return;

      // Skip header row
      final dataLines = lines.skip(1);

      final uids = <String>[];
      final uidDataEntries = <String>[];

      for (final line in dataLines) {
        if (line.trim().isEmpty) continue;

        final parts = line.split(',');
        if (parts.isEmpty) continue;

        final uid = parts[0].trim();
        if (uid.isEmpty) continue;

        uids.add(uid);

        // Store full data: uid|firstName|lastName|enumerator|region
        final firstName = parts.length > 1 ? parts[1].trim() : '';
        final lastName = parts.length > 2 ? parts[2].trim() : '';
        final enumerator = parts.length > 3 ? parts[3].trim() : '';
        final region = parts.length > 4 ? parts[4].trim() : '';

        uidDataEntries.add('$uid|$firstName|$lastName|$enumerator|$region');

        // Also populate memory cache
        _memoryCache.add(uid);
        _uidDataCache[uid] = {
          'firstName': firstName,
          'lastName': lastName,
          'enumerator': enumerator,
          'region': region,
        };
      }

      // Save to SharedPreferences
      await prefs.setStringList(_cacheKey, uids);
      await prefs.setStringList('${_cacheKey}_data', uidDataEntries);
      await prefs.setInt(_cacheVersionKey, _currentVersion);
    } catch (e) {
      // CSV loading failed - continue without offline cache
      // App will fall back to online-only validation
    }
  }

  /// Load full UID data from SharedPreferences
  static Future<void> _loadFullDataFromPrefs(SharedPreferences prefs) async {
    final dataEntries = prefs.getStringList('${_cacheKey}_data');
    if (dataEntries == null) return;

    for (final entry in dataEntries) {
      final parts = entry.split('|');
      if (parts.isEmpty) continue;

      final uid = parts[0];
      _uidDataCache[uid] = {
        'firstName': parts.length > 1 ? parts[1] : '',
        'lastName': parts.length > 2 ? parts[2] : '',
        'enumerator': parts.length > 3 ? parts[3] : '',
        'region': parts.length > 4 ? parts[4] : '',
      };
    }
  }

  /// Check if a UID is valid using the offline cache
  /// Returns true if UID exists in cached CSV data
  static bool isValidOffline(String uid) {
    if (!_isLoaded) return false;
    return _memoryCache.contains(uid.toUpperCase());
  }

  /// Get user data for a UID from offline cache
  /// Returns null if UID not found
  static Map<String, String>? getUserData(String uid) {
    if (!_isLoaded) return null;
    return _uidDataCache[uid.toUpperCase()];
  }

  /// Get first name for a UID
  static String? getFirstName(String uid) {
    final data = getUserData(uid);
    if (data == null) return null;
    final firstName = data['firstName'];
    return (firstName != null && firstName.isNotEmpty) ? firstName : null;
  }

  /// Get last name for a UID
  static String? getLastName(String uid) {
    final data = getUserData(uid);
    if (data == null) return null;
    final lastName = data['lastName'];
    return (lastName != null && lastName.isNotEmpty) ? lastName : null;
  }

  /// Get region for a UID
  static String? getRegion(String uid) {
    final data = getUserData(uid);
    if (data == null) return null;
    final region = data['region'];
    return (region != null && region.isNotEmpty) ? region : null;
  }

  /// Force reload from CSV (useful after app update)
  static Future<void> forceReload() async {
    _isLoaded = false;
    _memoryCache.clear();
    _uidDataCache.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove('${_cacheKey}_data');
    await prefs.remove(_cacheVersionKey);

    await loadFromCSV();
  }

  /// Get total count of cached UIDs (for debugging)
  static int get cachedCount => _memoryCache.length;

  /// Check if cache is loaded
  static bool get isLoaded => _isLoaded;
}
