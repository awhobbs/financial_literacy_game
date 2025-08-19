
String formatAmount(
    double value,
    String locale, {
      String currency = 'UGX',
      int decimalDigits = 0,
    }) {
  final sign = value < 0 ? '-' : '';
  final fixed = value.abs().toStringAsFixed(decimalDigits);

  // Split integer/fractional parts
  final parts = fixed.split('.');
  final intPart = parts[0];
  final fracPart = (parts.length > 1 && decimalDigits > 0) ? '.${parts[1]}' : '';

  // Insert thousands separators into the integer part
  final sb = StringBuffer();
  int count = 0;
  for (int i = intPart.length - 1; i >= 0; i--) {
    sb.write(intPart[i]);
    count++;
    if (i > 0 && count % 3 == 0) {
      sb.write(',');
    }
  }
  final grouped = sb.toString().split('').reversed.join();

  return '$sign$currency$grouped$fracPart';
}
