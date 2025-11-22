
import 'dart:ui' show Locale, PlatformDispatcher;
import 'package:flutter/foundation.dart';

import '../domain/utils/device_and_personal_data.dart';

class L10n {
  /// Fallback if nothing matches / nothing stored
  static const Locale defaultLocale = Locale('en');

  /// All supported locales (order is what you’ll see in the dropdown)
  static const List<Locale> all = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('es'),
    Locale('es', 'GT'),
    Locale('es', 'PE'),
    Locale('lg'),      // Luganda
    Locale('kn'),      // Kinyarwanda (per your ARB)
    Locale('ach'),     // Acholi
    Locale('nyn'),     // Runyankole
  ];

  /// Returns true if a locale is supported (by languageCode and optional countryCode)
  static bool isSupported(Locale l) {
    return all.any((loc) =>
        loc.languageCode == l.languageCode &&
        (loc.countryCode == null || loc.countryCode == l.countryCode));
  }

  /// Try to pick the best starting locale:
  /// 1) previously saved in SharedPreferences
  /// 2) device/system
  /// 3) defaultLocale
  static Future<Locale> getSystemLocale() async {
    final stored = await loadLocaleFromLocal();
    if (stored != null && isSupported(stored)) {
      debugPrint('Using stored locale: $stored');
      return stored;
    }

    final system = PlatformDispatcher.instance.locale;
    if (isSupported(system)) {
      debugPrint('Using system locale: $system');
      return system;
    }

    debugPrint('Falling back to default locale: $defaultLocale');
    return defaultLocale;
  }

  /// Human-friendly label for a locale in the dropdown
  static String labelFor(Locale locale) {
    switch ('${locale.languageCode}_${locale.countryCode ?? ''}') {
      case 'en_US':
      case 'en_':
      case 'en':
        return 'English';
      case 'es_GT':
        return 'Español (Guatemala)';
      case 'es_PE':
        return 'Español (Perú)';
      case 'es_':
      case 'es':
        return 'Español';
      case 'lg_':
      case 'lg':
        return 'Luganda';
      case 'kn_':
      case 'kn':
        return 'Kinyarwanda';
      case 'ach_':
      case 'ach':
        return 'Acholi';
      case 'nyn_':
      case 'nyn':
        return 'Runyankole';
      default:
        return locale.toLanguageTag();
    }
  }

  /// Convenience to check language-only support
  static bool supportsLanguage(Locale l) {
    return all.any((loc) => loc.languageCode == l.languageCode);
  }

  /// Simple currency conversion (tweak as needed)
  static double getConversionRate(Locale locale) {
    switch (locale.languageCode) {
      case 'en': return 1;
      case 'lg': return 4000;
      case 'kn': return 1000;
      case 'nyn': return 4000;
      case 'ach': return 4000;
      case 'es': return 1;
      default: return 1;
    }
  }
}
