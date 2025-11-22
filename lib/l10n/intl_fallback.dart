import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

const _unsupportedIntl = {'lg', 'ach'};

String intlLocaleFor(Locale l) =>
    _unsupportedIntl.contains(l.languageCode) ? 'en' : l.toString();

String intlLocaleCode(String localeName) {
  final code = localeName.split('_').first;
  return _unsupportedIntl.contains(code) ? 'en' : localeName;
}

String formatUgx(num amount, Locale l, {int decimalDigits = 0}) {
  final loc = intlLocaleFor(l);
  try {
    return NumberFormat.currency(
      locale: loc,
      name: 'UGX',
      decimalDigits: decimalDigits,
    ).format(amount);
  } catch (_) {
    return NumberFormat.currency(
      locale: 'en',
      name: 'UGX',
      decimalDigits: decimalDigits,
    ).format(amount);
  }
}
