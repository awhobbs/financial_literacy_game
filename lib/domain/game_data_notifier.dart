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
import 'concepts/round_data.dart';
import 'entities/levels.dart';
import 'concepts/recorded_data.dart';

import 'utils/database.dart';
import 'utils/utils.dart';
import 'utils/device_and_personal_data.dart';

import '../../offline/offline_storage.dart';
import '../../offline/offline_queue.dart';
import 'analytics/session_analytics.dart';

final gameDataNotifierProvider =
StateNotifierProvider<GameDataNotifier, GameData>(
        (ref) => GameDataNotifier());

class GameDataNotifier extends StateNotifier<GameData> {
  // ----------------------------------------------------------
  // ROUND TRACKING FIELDS
  // ----------------------------------------------------------
  String? _sessionId;
  DateTime? _roundStartedAt;
  int _currentRoundNumber = 0;
  double _lastSavingsRate = 0.0;
  double _lastLoanInterestRate = 0.0;
  bool _lastAssetDied = false;

  // Session-level accumulator (reset on each new session)
  SessionAccumulator? _sessionAccumulator;

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
      // Also save last round data
      OfflineStorage.saveLastRound({
        "roundNumber": _currentRoundNumber,
        "sessionId": _sessionId ?? "",
      });
    } catch (e) {
      debugPrint("Autosave failed: $e");
    }
  }

  // ----------------------------------------------------------
  // SESSION & ROUND TRACKING
  // ----------------------------------------------------------

  /// Start a new game session - call when player starts playing
  void startSession() {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _currentRoundNumber = 0;
    _sessionAccumulator = SessionAccumulator(
      uid: state.person.uid ?? 'UNKNOWN',
      sessionId: _sessionId!,
      startedAt: DateTime.now(),
    );
    debugPrint("Session started: $_sessionId");
  }

  /// Mark the start of a round - call when investment dialog opens
  void markRoundStart({double savingsRate = 0.0, double loanInterestRate = 0.0}) {
    _roundStartedAt = DateTime.now();
    _lastSavingsRate = savingsRate;
    _lastLoanInterestRate = loanInterestRate;
    _lastAssetDied = false;
    debugPrint("Round started at: $_roundStartedAt");
  }

  /// Mark that an asset died during this round
  void markAssetDied() {
    _lastAssetDied = true;
  }

  /// Get the current session ID
  String? get sessionId => _sessionId;

  /// Get the current round number
  int get currentRoundNumber => _currentRoundNumber;

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
    // Capture state BEFORE changes for round data
    final stateBefore = StateSnapshot(
      cash: state.cash,
      totalAssets: state.assets.fold(0.0, (sum, a) => sum + a.price),
      totalLoans: state.loans.fold(0.0, (sum, l) => sum + l.asset.price),
      totalIncome: calculateTotalIncome(),
      totalExpenses: calculateTotalExpenses(),
    );

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

    // save to Firestore (legacy)
    advancePeriodFirestore(
      newCashValue: newCash,
      buyDecision: buyDecision,
      offeredAsset: selectedAsset,
    );

    // Capture state AFTER changes for round data
    final stateAfter = StateSnapshot(
      cash: state.cash,
      totalAssets: state.assets.fold(0.0, (sum, a) => sum + a.price),
      totalLoans: state.loans.fold(0.0, (sum, l) => sum + l.asset.price),
      totalIncome: calculateTotalIncome(),
      totalExpenses: calculateTotalExpenses(),
    );

    // Increment round number and create RoundData
    _currentRoundNumber++;
    await _recordRoundData(
      buyDecision: buyDecision,
      selectedAsset: selectedAsset,
      stateBefore: stateBefore,
      stateAfter: stateAfter,
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
  // RECORD ROUND DATA TO OFFLINE QUEUE
  // ----------------------------------------------------------
  Future<void> _recordRoundData({
    required BuyDecision buyDecision,
    required Asset selectedAsset,
    required StateSnapshot stateBefore,
    required StateSnapshot stateAfter,
  }) async {
    final now = DateTime.now();
    final roundStarted = _roundStartedAt ?? now;
    final decisionTimeMs = now.difference(roundStarted).inMilliseconds;

    // Get decision string
    final decisionStr = switch (buyDecision) {
      BuyDecision.buyCash => 'buyCash',
      BuyDecision.loan => 'loan',
      BuyDecision.dontBuy => 'dontBuy',
    };

    // Get concepts tested
    final concepts = getConceptsTested(
      levelId: state.levelId,
      decision: decisionStr,
      assetRiskLevel: selectedAsset.riskLevel,
      loanInterestRate: _lastLoanInterestRate,
      hasSavingsRate: _lastSavingsRate > 0,
    );

    // Assess decision quality
    final quality = assessDecisionQuality(
      decision: decisionStr,
      cash: stateBefore.cash,
      assetPrice: selectedAsset.price,
      assetIncome: selectedAsset.income,
      assetRiskLevel: selectedAsset.riskLevel,
      assetLifeExpectancy: selectedAsset.lifeExpectancy,
      loanInterestRate: _lastLoanInterestRate,
      savingsRate: _lastSavingsRate,
    );

    // Compute speed flag for this round
    final speedFlag = SpeedFlag.fromMs(decisionTimeMs);

    // Feed session accumulator
    _sessionAccumulator?.recordRound(
      decisionTimeMs: decisionTimeMs,
      decision: decisionStr,
      decisionQuality: quality.name,
      levelId: state.levelId,
    );

    // Create RoundData (with speedFlag added)
    final roundData = RoundData(
      uid: state.person.uid ?? 'UNKNOWN',
      sessionId: _sessionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      levelId: state.levelId,
      roundNumber: _currentRoundNumber,
      roundStartedAt: roundStarted,
      decisionMadeAt: now,
      decisionTimeMs: decisionTimeMs,
      decision: decisionStr,
      stateBefore: stateBefore,
      stateAfter: stateAfter,
      offeredAsset: OfferedAssetData.fromAsset(selectedAsset),
      conceptsTested: concepts,
      decisionQuality: quality,
      assetDied: _lastAssetDied,
      speedFlag: speedFlag,
    );

    // Queue for offline sync
    final uid = state.person.uid ?? 'UNKNOWN';
    final queue = OfflineQueue(uid);
    await queue.add(roundData.toQueueAction());

    debugPrint("Round $currentRoundNumber queued for sync [$speedFlag, ${decisionTimeMs}ms]");
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
    final died = asset.riskLevel > Random().nextDouble();
    if (died) {
      markAssetDied(); // Track for round data
      await show(asset);
      return true;
    }
    return false;
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
  // QUEUE SESSION SUMMARY (call before resetting session)
  // ----------------------------------------------------------

  /// Public checkpoint — call on app background to preserve in-progress data
  Future<void> checkpointSessionSummary() => _queueSessionSummary();

  Future<void> _queueSessionSummary() async {
    if (_sessionAccumulator == null) return;
    // Only write summary if at least one round was played
    if (_sessionAccumulator!.roundCount == 0) return;

    final summary = _sessionAccumulator!.build();
    final uid = state.person.uid ?? 'UNKNOWN';
    final queue = OfflineQueue(uid);

    await queue.add(summary.toQueueAction());
    await queue.add(summary.toPlayerSummaryQueueAction());

    debugPrint("Session summary queued: ${summary.roundCount} rounds, "
        "${summary.durationFlag}, speed: ${summary.overallSpeedPattern}");
  }

  // ----------------------------------------------------------
  // RESET GAME
  // ----------------------------------------------------------
  void resetGame() {
    // Write session summary for the session that is ending
    _queueSessionSummary();

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

    // Start new session for round tracking
    startSession();

    saveLevelIDLocally(0);
    startGameSession(
      person: state.person,
      startingCash: levels[0].startingCash,
    );

    _autosave();
  }

  // ----------------------------------------------------------
  // RESTORE SESSION (for resume)
  // ----------------------------------------------------------
  Future<void> restoreSession() async {
    final lastRound = await OfflineStorage.loadLastRound();
    if (lastRound != null) {
      _sessionId = lastRound['sessionId'] as String?;
      _currentRoundNumber = lastRound['roundNumber'] as int? ?? 0;
      debugPrint("Session restored: $_sessionId, round: $_currentRoundNumber");
    } else {
      // No previous session, start fresh
      startSession();
    }
  }
}
