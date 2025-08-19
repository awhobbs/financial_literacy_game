
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../concepts/person.dart';
import '../game_data_notifier.dart';

Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    debugPrint('Running on ${webBrowserInfo.userAgent}');
  } else {
    try {
      final android = await deviceInfo.androidInfo;
      debugPrint('Running on Android ${android.model}');
    } catch (_) {
      try {
        final ios = await deviceInfo.iosInfo;
        debugPrint('Running on iOS ${ios.utsname.machine}');
      } catch (_) {
        // ignore
      }
    }
  }
}

Future<void> savePersonLocally(Person person) async {
  final prefs = await SharedPreferences.getInstance();
  if (person.firstName != null) prefs.setString('firstName', person.firstName!);
  if (person.lastName != null) prefs.setString('lastName', person.lastName!);
  if (person.uid != null) prefs.setString('uid', person.uid!);
  if (person.exists()) prefs.setBool('personExists', true);
}

Future<bool> loadPerson({required WidgetRef ref}) async {
  final prefs = await SharedPreferences.getInstance();
  final exists = prefs.getBool('personExists') ?? false;
  if (!exists) return false;

  final firstName = prefs.getString('firstName');
  final lastName = prefs.getString('lastName');
  final uid = prefs.getString('uid');

  if (firstName == null || lastName == null) return false;

  final person = Person(firstName: firstName, lastName: lastName, uid: uid);
  ref.read(gameDataNotifierProvider.notifier).setPerson(person);
  return true;
}

Future<bool> loadLevelIDFromLocal({required WidgetRef ref}) async {
  final prefs = await SharedPreferences.getInstance();
  int? savedLastPlayedLevelID = prefs.getInt('lastPlayedLevelID');
  if (savedLastPlayedLevelID == null) {
    return false;
  } else {
    ref.read(gameDataNotifierProvider.notifier).loadLevel(savedLastPlayedLevelID);
    return true;
  }
}

void saveLevelIDLocally(int levelID) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('lastPlayedLevelID', levelID);
}

Future<void> saveLocalLocally(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('languageCode', locale.languageCode);
  if (locale.countryCode != null) {
    await prefs.setString('countryCode', locale.countryCode!);
  } else {
    await prefs.remove('countryCode');
  }
}

Future<Locale?> loadLocaleFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('languageCode');
  final String? countryCode = prefs.getString('countryCode');

  if (languageCode == null || languageCode.isEmpty) {
    return null;
  }
  if (countryCode == null || countryCode.isEmpty) {
    return Locale(languageCode);
  }
  return Locale(languageCode, countryCode);
}
