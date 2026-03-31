import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:financial_literacy_game/l10n/l10n.dart';

import '../../config/constants.dart';
import '../concepts/person.dart';
import '../concepts/asset.dart';
import '../concepts/loan.dart';
import '../concepts/recorded_data.dart';
import '../utils/utils.dart';

class GameData {
  final Person person;
  final Locale locale;

  final double cash;
  final int levelId;
  final int period;
  final double cashInterest;

  final double personalIncome;
  final double personalExpenses;

  final ConfettiController confettiController;

  final List<Asset> assets;
  final List<Loan> loans;

  final bool isBankrupt;
  final bool currentLevelSolved;
  final bool gameIsFinished;

  final List<RecordedData> recordedDataList;

  GameData({
    required this.person,
    required this.locale,
    required this.cash,
    required this.personalIncome,
    required this.personalExpenses,
    required this.confettiController,
    this.levelId = 0,
    this.period = 1,
    this.cashInterest = defaultCashInterest,
    this.assets = const [],
    this.loans = const [],
    this.isBankrupt = false,
    this.currentLevelSolved = false,
    this.gameIsFinished = false,
    this.recordedDataList = const [],
  });

  // ----------------------------------------------------------
  // COPYWITH (NO CHANGES TO YOUR GAME LOGIC)
  // ----------------------------------------------------------
  GameData copyWith({
    Person? person,
    Locale? locale,
    int? levelId,
    int? period,
    double? cash,
    double? cashInterest,
    double? personalIncome,
    double? personalExpenses,
    ConfettiController? confettiController,
    List<Asset>? assets,
    List<Loan>? loans,
    bool? isBankrupt,
    bool? currentLevelSolved,
    bool? gameIsFinished,
    List<RecordedData>? recordedDataList,
  }) {
    return GameData(
      person: person ?? this.person.copyWith(),
      locale: locale ?? this.locale,
      levelId: levelId ?? this.levelId,
      period: period ?? this.period,
      cash: cash ?? this.cash,
      cashInterest: cashInterest ?? this.cashInterest,
      personalIncome: personalIncome ?? this.personalIncome,
      personalExpenses: personalExpenses ?? this.personalExpenses,
      confettiController: confettiController ?? this.confettiController,
      assets: assets ?? copyAssetArray(this.assets),
      loans: loans ?? copyLoanArray(this.loans),
      isBankrupt: isBankrupt ?? this.isBankrupt,
      currentLevelSolved: currentLevelSolved ?? this.currentLevelSolved,
      gameIsFinished: gameIsFinished ?? this.gameIsFinished,
      recordedDataList:
      recordedDataList ?? copyRecordedDataArray(this.recordedDataList),
    );
  }

  // ----------------------------------------------------------
  // GETTERS (unchanged)
  // ----------------------------------------------------------
  int get pigs => assets
      .where((a) => a.type == AssetType.pig)
      .fold(0, (sum, a) => sum + a.numberOfAnimals);

  int get chickens => assets
      .where((a) => a.type == AssetType.chicken)
      .fold(0, (sum, a) => sum + a.numberOfAnimals);

  int get goats => assets
      .where((a) => a.type == AssetType.goat)
      .fold(0, (sum, a) => sum + a.numberOfAnimals);

  double get conversionRate => L10n.getConversionRate(locale);
}
