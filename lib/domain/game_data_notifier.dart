import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';

import '../config/constants.dart';
import '../l10n/intl_fallback.dart';
import '../l10n/l10n.dart';

import 'concepts/asset.dart';
import 'concepts/game_data.dart';
import 'concepts/loan.dart';
import 'concepts/person.dart';
import 'entities/levels.dart';
import 'concepts/recorded_data.dart';

import 'utils/database.dart';
import 'utils/utils.dart';
import 'utils/device_and_personal_data.dart';

import '../../offline/offline_storage.dart';

final gameDataNotifierProvider =
StateNotifierProvider<GameDataNotifier, GameData>(
        (ref) => GameDataNotifier());

class GameDataNotifier extends StateNotifier<GameData> {
  GameDataNotifier()
      : super(
    GameData(
      person: Person(),
      locale: L10n.defaultLocale,
      cash: levels[0].startingCash,
      personalIncome: levels[0].includePersonalIncome
          ? levels[0].personalIncome
          : 0,
      personalExpenses: levels[0].includePersonalIncome
          ? levels[0].personalExpenses
          : 0,
      confettiController: ConfettiController(),
      recordedDataList: [
        RecordedData(
          levelId: 0,
          cashValues: [levels[0].startingCash],
        ),
      ],
    ),
  );

  // ----------------------------------------------------------
  // 🔥 UNIVERSAL AUTOSAVE (SAFE — no JSON!)
  // ----------------------------------------------------------
  void _autosave() {
    try {
      OfflineStorage.saveSimpleState({
        "cash": state.cash,
        "levelId": state.levelId,
        "period": state.period,
        "locale": state.locale.languageCode,
      });
    } catch (e) {
      debugPrint("Autosave failed: $e");
    }
  }

  // ----------------------------------------------------------
  // PERSON
  // ----------------------------------------------------------
  void setPerson(Person newPerson) {
    state = state.copyWith(person: newPerson);
    _autosave();
  }

  // ----------------------------------------------------------
  // LOCALE
  // ----------------------------------------------------------
  void setLocale(Locale newLocale) {
    if (L10n.all.contains(newLocale)) {
      Intl.defaultLocale = intlLocaleFor(newLocale);
      state = state.copyWith(locale: newLocale);
      _autosave();
    }
  }

  // ----------------------------------------------------------
  // LOAD LEVEL
  // ----------------------------------------------------------
  void loadLevel(int levelID) {
    _loadLevel(levelID);
    _autosave();
  }

  // ----------------------------------------------------------
  // CONFETTI
  // ----------------------------------------------------------
  void showConfetti() async {
    state.confettiController.play();
    await Future.delayed(const Duration(seconds: showConfettiSeconds));
    state.confettiController.stop();
  }

  // ----------------------------------------------------------
  // ADVANCE PERIOD
  // ----------------------------------------------------------
  void advance({
    required double newCashInterest,
    required BuyDecision buyDecision,
    required Asset selectedAsset,
  }) async {
    // increment period
    state = state.copyWith(period: state.period + 1);
    state = state.copyWith(cashInterest: newCashInterest);

    // new cash
    state = state.copyWith(cash: state.cash * (1 + state.cashInterest));

    // age assets
    List<Asset> survivedAssets = [];
    for (var asset in state.assets) {
      if (asset.age < asset.lifeExpectancy) {
        survivedAssets.add(asset.copyWith(age: asset.age + 1));
      }
    }
    state = state.copyWith(assets: survivedAssets);

    // age loans
    List<Loan> activeLoans = [];
    for (var loan in state.loans) {
      if (loan.age < loan.termInPeriods) {
        activeLoans.add(loan.copyWith(age: loan.age + 1));
      }
    }
    state = state.copyWith(loans: activeLoans);

    // apply income/expenses
    double income = calculateTotalIncome();
    double expenses = calculateTotalExpenses();
    double newCash = state.cash + income - expenses;

    state = state.copyWith(cash: newCash);

    // save to Firestore
    advancePeriodFirestore(
      newCashValue: newCash,
      buyDecision: buyDecision,
      offeredAsset: selectedAsset,
    );

    // bankrupt?
    if (state.cash < 0) {
      state = state.copyWith(isBankrupt: true);
    }

    // level completion
    if (state.cash >= levels[state.levelId].cashGoal) {
      if (state.levelId + 1 >= levels.length) {
        state = state.copyWith(gameIsFinished: true);
      } else {
        state = state.copyWith(currentLevelSolved: true);
      }
    }

    _autosave();
  }

  // ----------------------------------------------------------
  // BUY ASSET
  // ----------------------------------------------------------
  Future<bool> buyAsset(
      Asset asset,
      Function showNotEnoughCash,
      Function showAnimalDied,
      double newCashInterest,
      ) async {
    if (state.cash < asset.price) {
      showNotEnoughCash();
      return false;
    }

    state = state.copyWith(cash: state.cash - asset.price);

    bool died = await _animalDied(asset, showAnimalDied);
    if (!died) _addAsset(asset);

    advance(
      newCashInterest: newCashInterest,
      buyDecision: BuyDecision.buyCash,
      selectedAsset: asset,
    );

    _autosave();
    return true;
  }

  // ----------------------------------------------------------
  // LOAN ASSET
  // ----------------------------------------------------------
  Future<void> loanAsset(
      Loan loan,
      Asset asset,
      Function showAnimalDied,
      double newCashInterest,
      ) async {
    bool died = await _animalDied(asset, showAnimalDied);
    if (!died) _addAsset(asset);

    _addLoan(loan.copyWith(asset: asset));

    advance(
      newCashInterest: newCashInterest,
      buyDecision: BuyDecision.loan,
      selectedAsset: asset,
    );

    _autosave();
  }

  // ----------------------------------------------------------
  // RESET LEVEL
  // ----------------------------------------------------------
  void restartLevel() {
    restartLevelFirebase(
      level: state.levelId + 1,
      startingCash: levels[state.levelId].startingCash,
    );

    state = state.copyWith(isBankrupt: false);
    _loadLevel(state.levelId);

    _autosave();
  }

  // ----------------------------------------------------------
  // MOVE TO NEXT LEVEL
  // ----------------------------------------------------------
  void moveToNextLevel() {
    int next = state.levelId + 1;

    _loadLevel(next);
    newLevelFirestore(
      levelID: next,
      startingCash: levels[next].startingCash,
    );

    _autosave();
  }

  // ----------------------------------------------------------
  // INTERNAL
  // ----------------------------------------------------------
  void _loadLevel(int id) {
    if (id < 0 || id >= levels.length) return;

    state = state.copyWith(
      levelId: id,
      cash: levels[id].startingCash,
      assets: [],
      loans: [],
      period: 1,
      currentLevelSolved: false,
    );

    saveLevelIDLocally(id);
  }

  void _addAsset(Asset newAsset) {
    state = state.copyWith(assets: [...state.assets, newAsset]);
  }

  void _addLoan(Loan newLoan) {
    state = state.copyWith(loans: [...state.loans, newLoan]);
  }

  Future<bool> _animalDied(Asset asset, Function show) async {
    return asset.riskLevel > Random().nextDouble()
        ? await show(asset)
        : false;
  }

  // ----------------------------------------------------------
  // CALCULATIONS
  // ----------------------------------------------------------
  double calculateTotalExpenses() {
    double loanPayments =
    state.loans.fold(0, (sum, l) => sum + l.paymentPerPeriod);

    return loanPayments +
        (levels[state.levelId].includePersonalIncome
            ? state.personalExpenses
            : 0);
  }

  double calculateTotalIncome() {
    double assetIncome =
    state.assets.fold(0, (sum, a) => sum + a.income);

    return assetIncome +
        (levels[state.levelId].includePersonalIncome
            ? state.personalIncome
            : 0);
  }

  double convertAmount(double usd) =>
      state.conversionRate * usd;

  double calculateIncome(AssetType type) {
    return state.assets
        .where((a) => a.type == type)
        .fold(0, (sum, a) => sum + a.income);
  }

  // ----------------------------------------------------------
  // RESET GAME
  // ----------------------------------------------------------
  void resetGame() {
    state = GameData(
      person: state.person,
      locale: state.locale,
      cash: levels[0].startingCash,
      personalIncome:
      levels[0].includePersonalIncome ? levels[0].personalIncome : 0,
      personalExpenses:
      levels[0].includePersonalIncome ? levels[0].personalExpenses : 0,
      confettiController: state.confettiController,
    );

    saveLevelIDLocally(0);
    startGameSession(
      person: state.person,
      startingCash: levels[0].startingCash,
    );

    _autosave();
  }
}
