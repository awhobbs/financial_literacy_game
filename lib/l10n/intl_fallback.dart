import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

const _unsupportedIntl = {'lg', 'ach', 'nyn', 'kn'};

String intlLocaleFor(Locale l) =>
    _unsupportedIntl.contains(l.languageCode) ? 'en' : l.toString();

String intlLocaleCode(String localeName) {
  final code = localeName.split('_').first;
  return _unsupportedIntl.contains(code) ? 'en' : localeName;
}

String _currencyForLang(String lang) {
  if (lang == 'es') return 'Pesos';
  return 'UGX'; // English and all Uganda locales
}

String formatUgx(num amount, Locale l, {int decimalDigits = 0}) {
  final loc = intlLocaleFor(l);
  final currency = _currencyForLang(l.languageCode);
  try {
    return NumberFormat.currency(
      locale: loc,
      name: currency,
      decimalDigits: decimalDigits,
    ).format(amount);
  } catch (_) {
    return NumberFormat.currency(
      locale: 'en',
      name: currency,
      decimalDigits: decimalDigits,
    ).format(amount);
  }
}
