// lib/domain/utils/utils.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:financial_literacy_game/l10n/app_localizations.dart';
import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:financial_literacy_game/domain/utils/intl_fallback.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/recorded_data.dart';
import '../concepts/asset.dart';
import '../concepts/level.dart';
import '../concepts/loan.dart';

List<RecordedData> copyRecordedDataArray(List<RecordedData> recordedDataList) {
  final copiedRecordedDataList = <RecordedData>[];
  for (final recordedData in recordedDataList) {
    copiedRecordedDataList.add(recordedData);
  }
  return copiedRecordedDataList;
}

List<double> copyCashArray(List<double> cashList) {
  final copiedCashList = <double>[];
  for (final cashValue in cashList) {
    copiedCashList.add(cashValue);
  }
  return copiedCashList;
}

List<Asset> copyAssetArray(List<Asset> assetList) {
  final copiedAssetList = <Asset>[];
  for (final asset in assetList) {
    copiedAssetList.add(asset.copyWith());
  }
  return copiedAssetList;
}

// helper method to copy a list of loans
List<Loan> copyLoanArray(List<Loan> loanList) {
  final copiedLoanList = <Loan>[];
  for (final loan in loanList) {
    copiedLoanList.add(loan.copyWith());
  }
  return copiedLoanList;
}

// get random double value
double getRandomDouble({
  required double start,
  required double end,
  required double steps,
}) {
  final randomStepList = List<double>.generate(
    (end * 100 - start * 100) ~/ (steps * 100) + 1,
        (index) => start + index * steps,
  );
  return randomStepList[Random().nextInt(randomStepList.length)];
}

String generateCashTipMessage({
  required Asset asset,
  required Level level,
  required BuildContext context,
  required WidgetRef ref,
}) {
  final l10n = AppLocalizations.of(context)!;
  final localeCode = Localizations.localeOf(context).toString();

  String tipString = '${l10n.cash}: ';

  final profit = asset.income * asset.lifeExpectancy - asset.price;
  final convertedProfit =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(profit);

  final convertedIncome =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(asset.income);
  final convertedPrice =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(asset.price);

  final profitString =
  l10n.cashValue(formatAmount(convertedProfit, localeCode, currency: 'UGX'));

  tipString +=
  '(${l10n.cashValue(formatAmount(convertedIncome, localeCode, currency: 'UGX'))} x '
      '${asset.lifeExpectancy}) - '
      '${l10n.cashValue(formatAmount(convertedPrice, localeCode, currency: 'UGX'))} = '
      '$profitString';

  return tipString;
}

String generateLoanTipMessage({
  required Asset asset,
  required Level level,
  required BuildContext context,
  required WidgetRef ref,
}) {
  final l10n = AppLocalizations.of(context)!;
  final localeCode = Localizations.localeOf(context).toString();

  String tipString = '${l10n.loan(1)}: ';

  final profit = asset.income * asset.lifeExpectancy -
      asset.price * (1 + level.loan.interestRate);
  final convertedProfit =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(profit);

  final convertedIncome =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(asset.income);
  final convertedPrice =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(asset.price);

  final priceTimesRate = convertedPrice * (1 + level.loan.interestRate);

  final profitString =
  l10n.cashValue(formatAmount(convertedProfit, localeCode, currency: 'UGX'));

  tipString +=
  '(${l10n.cashValue(formatAmount(convertedIncome, localeCode, currency: 'UGX'))} x ${asset.lifeExpectancy}) - '
      '(${l10n.cashValue(formatAmount(priceTimesRate, localeCode, currency: 'UGX'))}) = '
      '$profitString';

  return tipString;
}

String generateInterestAmountTipMessage({
  required Asset asset,
  required Level level,
  required BuildContext context,
  required WidgetRef ref,
}) {
  final l10n = AppLocalizations.of(context)!;
  final localeCode = Localizations.localeOf(context).toString();

  String tipString = '${l10n.interestCash}: ';

  final interest = asset.price * (level.loan.interestRate);
  final convertedInterest =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(interest);
  final convertedPrice =
  ref.read(gameDataNotifierProvider.notifier).convertAmount(asset.price);

  final interestString = l10n.cashValue(
    formatAmount(convertedInterest, localeCode, currency: 'UGX'),
  );

  tipString +=
  '(${l10n.cashValue(formatAmount(convertedPrice * level.loan.interestRate, localeCode, currency: 'UGX'))}) = '
      '$interestString';

  return tipString;
}

// extension to allow capitalization of first letter in strings
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

void showErrorSnackBar({
  required BuildContext context,
  required String errorMessage,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorPalette().errorSnackBarBackground,
      content: Text(
        errorMessage,
        style: TextStyle(color: ColorPalette().darkText),
      ),
    ),
  );
}

String removeTrailing(String pattern, String from) {
  if (pattern.isEmpty) return from;
  var i = from.length;
  while (from.startsWith(pattern, i - pattern.length)) {
    i -= pattern.length;
  }
  return from.substring(0, i);
}

String removeLeading(String pattern, String from) {
  if (pattern.isEmpty) return from;
  var i = 0;
  while (from.startsWith(pattern, i)) {
    i += pattern.length;
  }
  return from.substring(i);
}
